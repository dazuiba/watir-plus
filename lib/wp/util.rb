class Template
	
	def try(args)
		@proc.call(@page, args)
	end

	def initialize(page,name,&block)
		@page = page
		@name = name
		@proc = block
	end
	
end


class Util

  def self.join_css(*css)
    css.join " "
  end
	
	def self.to_url(options)
		if(options.is_a? String)
			return options
		end
		
		options.reverse_merge!(:host=>"www", :domain=>WP[:domain])
		params = options[:params] ? "?"+options[:params] : ""			
		"http://#{options[:host]}.#{options[:domain]}/#{options[:path]}#{params}"
	end
		
	def self.add_leading_slash(str)
		if str=~/^\//
			str
		else
			"/"+str
		end
	end
end
