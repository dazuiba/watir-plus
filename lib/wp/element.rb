class ElementCollection
	attr_reader :elements, :container, :name, :css
  include Enumerable
	def initialize(container, name, css)
		@container = container
		@name = name
		@css = css
		@elements = []
	end
	
  def add_element(type, name, ele_css, &block)
		ele_css = Util.join_css(container.abs_css, self.css, ele_css)
		@elements << Element.create_by_css(self.container, type, name, ele_css)
	end

  def each
    @elements.each{|e|yield e}
  end
	
  def size
    @elements.size
  end

	def method_missing(method, *args)
		if /^add_(\w+)/ =~ method.to_s
			assert args.size==2
			puts "#{method}, #{args.inspect}"
			self.add_element $1, args.first, args.last
		elsif found =  @elements.find{|e|e.name == method}
			found
		else
			super
		end
	end
end

class Element
	attr_accessor :container, :type, :name, :options
	

	def self.create_by_css(container, type, name, css)
		new(container, type, name, :css => css)
	end
	
	def initialize(container,type, name, options)	
		assert container
		assert name
		@container = container
		@type = type
		@name = name
		@options = options
	end

	def method_missing(method, *args)
		do_find_element.send(method,*args)
	end

	private
	def do_find_element
		@watir_element||= begin
      if(options[:css])
         watir_element_class = Watir::Element.by_type(type)
         watir_element_class.new(container.browser,
                                 :ole_object,
                                  container.find_ole_element(css))
      else
         @container.browser.find_element(type, options)
      end


    end
	end
end