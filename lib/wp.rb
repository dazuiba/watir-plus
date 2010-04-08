require "wp/assert_ext"
require "wp/element"
require "wp/page_module"
require "wp/page"
require "wp/page_finder"
require "wp/util"
require "wp/wp_browser"
require 'wp/watir_patches'
require 'watir/ie'

require 'watir/ie'
WatirPatches.patch!

B = WPBrowser.instance

module WP
	class <<self
		def []=(key,value)
			@globle||={}
			@globle[key] = value
		end

		def [](key)
			@globle||={}
			@globle[key]
		end
		
		def test(name, options={}, &block)
      return if options[:run]==false
			yield
		end
		
		def goto(options)
			B.goto Util.to_url(options)
			yield B.current_page
		end
		
		def create_page(name,&block)
			B.create_page(name,&block)
		end

    def url_hock(&block)
       self[:hocks]||=[]
       self[:hocks]<<block
    end

	end	
end





