class ElementCollection
	attr_reader :elements, :container, :name, :css, :type
  include Enumerable
	def initialize(container, type, name, css)
		@container = container
		@name = name
		@css = css
    @type = type
	end
	
  #  def add_element(type, name, ele_css, &block)
  #		ele_css = Util.join_css(container.abs_css, self.css, ele_css)
  #		@elements << Element.create_by_css(self.container, type, name, ele_css)
  #	end

  def elements
    @elements||=container.browser.__find_ole_elements(abs_css).map { |ole_object|
      Element.create_by_ole(container, type, name, ole_object)
    }
  end

  def method_missing(method,*args,&block)
    if elements.respond_to? method
      elements.send method, *args,&block
    else
      super
    end
  end

  def abs_css
    Util.join_css(container.abs_css, css)
  end

  #	def method_missing(method, *args)
  #		if /^add_(\w+)/ =~ method.to_s
  #			assert args.size==2
  #			puts "#{method}, #{args.inspect}"
  #			self.add_element $1, args.first, args.last
  #		elsif found =  @elements.find{|e|e.name == method}
  #			found
  #		else
  #			super
  #		end
  #	end
end

class Element
	attr_accessor :container, :type, :name, :options
	

	def self.create_by_ole(container, type, name, ole_object)
		new(container, type, name, :ole_object => ole_object)
	end
	
	def initialize(container,type, name, options)	
		assert container
		assert name
		@container = container
		@type = type
		@name = name
		@options = options
    assert !options.blank?
	end

	def method_missing(method, *args)
		result = do_find_element.send(method,*args)
    if result.is_a?(Float)
      WP.current_page
    else
      result
    end
	end

	private
	def do_find_element
		@watir_element||= begin
      @container.browser.find_element(type, options)
    end
	end
end