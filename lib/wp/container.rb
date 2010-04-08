module Container
	def add_element_or_collection(type, name, options, &block)		
    if Util.plural_string(type)
      return add_element_collection(type.singularize,name, options, &block)
    else
    	add_element(type, name, options, &block)
  	end
	end
  
	def method_missing(method, *args)
		if /^add_(\w+)/ =~ method.to_s
			assert args.size==2
			add_element_or_collection $1, args[0], args[1]
		elsif found =  (collections + elements).find{|e|e.name == method}
			found
		else
			super
		end
	end
	
	private
		
	def add_element(type, name, options, &block)
    element = Element.new(self, type, name, options)
    yield element if block_given?
		elements << element
    element
	end

	def add_element_collection(type, name, css, &block)
    result = ElementCollection.new(self, type, name, css)
    yield result  if block_given?
		collections<< result
    result
	end

  def elements
    @element||=[]
  end

  def abs_css
     assert false
  end

  def collections
    @collections||=[]
  end
end