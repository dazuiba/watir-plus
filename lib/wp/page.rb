class Page
	attr_accessor :host, :path, :name, :elements, :modules, :reg_path, :attrs, :checker
	include Container
	def initialize(name)
		@name = name.to_sym
		@elements = []
    @modules  = []
    @attrs = {}
    @checker = PageChecker.new(self)
	end
	
	def create_module(name,find_options)
    result = PageModule.new(self, name, find_options)
    yield result   if block_given?
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
	
	def browser
		B
	end

  def add_attr(key, value)
    @attrs[key] = value
  end

  def abs_css
    ""
  end

 
end




