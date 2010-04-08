class PageModule
  attr_reader :parent, :name, :css, :elements
	def initialize(parent, name, css)
		@parent = parent
		@name = name
		@css = css
		@collections = []
		@elements    = []
	end	
  
	def browser
		@parent.browser
	end
	
	def abs_css
		current = self
		result_css = current.css
		while current.parent.is_a? self.class			
			result_css = join_css(result_css, current.parent.css)
			current = current.parent
		end
    result_css
	end
	
	def add_collection(name, css, &block)
    result = ElementCollection.new(self, name, css)
    yield result
		@collections << result
    result
	end
	
	def add_element(type, name, css, &block)
		css = Util.join_css(abs_css, element_css)
    element = Element.create_by_css(self, type, name, css)
		@elements << element
    element
	end
	
	def css
		@css
	end

  
  def find_ole_element(css)
  	result = find_ole_elements(css)
  	assert result.size==1, "css: #{css}, result: #{result.inspect} size shoule be 1 but #{result.size}"
  	result
  end

  def find_ole_elements(css)
    browser.find_html_elements(Util.join_css(abs_css, css)).map do |html_ele|
    	browser.element_by_absolute_xpath(html_ele.path)
    end
  end
  
  
	def method_missing(method, *args)
		if /^add_(\w+)/ =~ method.to_s
			assert args.size==2
			self.add_element $1, args[0], args[1]
		elsif found =  (@collections + @elements).find{|e|e.name == method}
			found
		else
			super
		end
	end
		
end