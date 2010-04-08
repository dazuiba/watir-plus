class WPBrowser
	include Singleton
	attr_accessor :browser
	
	def initialize
		@browser_clazz = Watir::IE
	end
	
	def create_page(name, &block)
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
    return find_element_by_css(type, options) if options.is_a?(String)
		if way=options[:kv]
			k,v = way.split(":",2)
      send(type, k,v)
		elsif way=options[:xpath]
      assert false
    elsif way=options[:css]
      return find_element_by_css(type, way)
    elsif way=options[:ole_object]
      return __find_element_by_ole_object(type, way)
		else
			assert false, "should input correct arguments, #{options.inspect}"
		end
	end

  def find_element_by_css(type, css)
     __find_element_by_ole_object(type, __find_ole_element(css))
  end
	
  def __find_ole_element(css)
  	result = __find_ole_elements(css)
  	assert result.size==1, "css: #{css}, result: #{result.inspect} size shoule be 1 but #{result.size}"
  	result.first
  end


  def __find_ole_elements(css)
    find_html_elements(css).map do |html_element|
    	__html_element_to_ole(html_element)
    end
  end
  
  def __find_element_by_ole_object(type, ole_object)
     watir_element_class = Watir::Element.by_type(type)
     watir_element_class.new(browser,:ole_object,ole_object)
  end



  def html_element_to_watir(html_element, type)
    __find_element_by_ole_object type, __html_element_to_ole(html_element)
  end

  def __html_element_to_ole(html_element)
    browser.send(:element_by_absolute_xpath, html_element.path)
  end

  def find_html_element(css)
  	result = find_html_elements(css)
  	assert result.size==1, "css:#{css}, result.size: #{result.size}"
  	result.first
  end

  def find_html_elements(element_css)
    begin
      browser.xmlparser_document_object.css(element_css)
    rescue Exception => ex
      puts "css: #{element_css}"
      raise ex
    end

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