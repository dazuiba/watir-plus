class WPBrowser
	include Singleton
	attr_accessor :browser
	
	def initialize
		@browser_clazz = Watir::IE
	end
	
	def create_page(name,&block)
		page = Page.new(name)
		yield page
		@pages ||=[]
		@pages << page		
	end

	def current_page
    check_url_hock!
		PageFinder.find(@pages,self.url)
	end
	
	def method_missing(method,*args)
    puts "WPBrowser:: method: #{method}--> #{args.inspect}"
		browser.send(method,*args)
	end
	
	def find_element(type,options)
		k,v = if way=options[:kv]
			way.split(":",2)
		elsif way=options[:xpath]
			[:xpath, way]
		elsif way = options[:css]
			[:css, way]
		else
			assert false, "should input correct arguments, #{options.inspect}"
		end

		send(type, k,v)
	end
	
  def find_html_element(css)
  	result = find_html_elements(css)
  	assert result.size==1
  	result.first
  end

  def find_html_elements(element_css)
    browser.xmlparser_document_object.css(element_css)
  end

  def check_url_hock!
    if hocks = WP[:hocks]
      hocks.each{|e|e.call self.url}
    end
  end
  
	
	private
	def browser
		@browser ||= @browser_clazz.new
	end
end