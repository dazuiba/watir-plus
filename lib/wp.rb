require "wp/assert_ext"
require "wp/string_ext"
require "wp/element"
require "wp/container"
require "wp/page_module"
require "wp/page"
require "wp/page_checker"
require "wp/page_finder"
require "wp/util"
require "wp/wp_browser"
require 'wp/watir_patches'
require 'watir/ie'

require 'watir/ie'

WIN32OLE.codepage =  WIN32OLE::CP_ACP
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
		
    def test_flow(name, options={}, &block)
      return if options[:run]==false
			yield
		end

		def test(name, options={}, &block)
      return if options[:run]==false
			yield
		end
		
		def goto(options)
			B.goto Util.to_url(options)
      page = B.current_page
			yield page if block_given?
      page
		end

    def current_page
      B.current_page
    end
		
		def create_page(name,&block)
			B.create_page(name,&block)
		end

    def url_hock(&block)
       self[:hocks]||=[]
       self[:hocks]<<block
    end

    def to_watir(html_elem, type=html_elem.name)
      assert html_elem
      B.html_element_to_watir(html_elem,type)
    end

	end	
end





