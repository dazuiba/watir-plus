class PageModule
  attr_reader :parent, :name, :css, :elements
  include Container
	def initialize(parent, name, css)
		@parent = parent
		@name = name
		@css = css
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
	
	def add_element(type, name, css, &block)
		super(type, name, :css=>Util.join_css(abs_css, css), &block)
	end
	
  def html_elements
    browser.find_html_elements(css)
  end
  
	def css
		@css
	end
end