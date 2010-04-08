class Page
	attr_accessor :host, :path, :name, :elements, :modules
	def initialize(name)
		@name = name.to_sym
		@elements = []
    @modules  = []
	end
	
	def create_module(name,find_options)
    result = PageModule.new(self, name, find_options)
    yield result
		@modules << result
    result
	end
	
	def get_module(name)
		@modules.find{|e|e.name==name}
	end
	
	
	def create_template(name, &block)
		tpl = Template.new(self,name,&block)
		tpl
	end
	
	def page_should_be?(page)
		self.name == page.to_sym
	end

	def path=(pt)
		@path = Util.add_leading_slash(pt)
	end
	
	def url
		Util.to_url({:host=>host, :path => path})
	end
	
	def method_missing(method, *args)
		if /^add_(\w+)/ =~ method.to_s
			assert args.size>=1
				
			options = args.extract_options!
			self.add_element $1, args.first, options
		elsif found =  @elements.find{|e|e.name == method}
			found
		else
			super
		end
	end
	
	def browser
		B
	end

	def add_element(type, name, options={})
		@elements||=[]
		@elements << Element.new(self,type, name, options)
	end
end




