require 'active_support'
require 'watir'
require 'uri'
$:.unshift File.dirname(__FILE__)
require "assert_ext"



module Tiny
	class <<self
		def []=(key,value)
			@globle||={}
			@globle[key] = value
		end

		def [](key)
			@globle||={}
			@globle[key]
		end
		
		def test(name, &block)
			yield
		end
		
		def goto(options)
			B.goto Util.to_url(options)  
			yield B.current_page
		end
		
		def create_page(name,&block)
			B.create_page(name,&block)
		end

	end	
end


class TinyBrowser
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
		PageFinder.find(@pages,self.url)
	end
	
	def method_missing(method,*args)		
		browser.send(method,*args)
	end
	
	def find_element(type,options)
		k,v = if way=options[:kv]
			way.split(":")
		elsif way=options[:xpath]
			[:xpath, way]
		elsif way = options[:css]
			[:css, way]
		else
			assert false, "should input correct arguments, #{options.inspect}"
		end

		send(type, k,v)
	end

	private
	def browser
		@browser ||= @browser_clazz.new
	end
end

B = TinyBrowser.instance



class Util

	def self.to_url(options)
		if(options.is_a? String)
			return options
		end
		
		options.reverse_merge!(:host=>"www", :domain=>Tiny[:domain])
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

class PageFinder
	def self.find(pages, url)
		bingo = pages.find do |page|
			same_page?({:host=>page.host,:path=>page.path}, url)
		end
		assert bingo, "没有找到此URL对应的page url:#{url}"
		bingo
	end

	def	self.same_page?(path, url)		
		uri = URI.parse(url)
		url_host = uri.host.split(".").first
		url_path = uri.path
		#puts "#{url_path} == #{path[:path]}"
		(url_host == path[:host]) && (url_path == path[:path])
	end

end

class Page
	attr_accessor :host, :path, :name, :elements
	def initialize(name)
		@name = name.to_sym
		@elements = []
	end
	
	def create_template(name, &block)
		tpl = Template.new(self,name,&block)
		tpl
	end
	
	def page_should_be?(page)
		self.name == page.to_sym
	end

	def path=(pt)
		@path = Util.add_leading_slash(pt)
	end
	
	def url
		Util.to_url({:host=>host, :path => path})
	end
	
	def method_missing(method, *args)
		if /^add_(\w+)/ =~ method.to_s
			assert args.size>=1
				
			options = args.extract_options!
			puts "#{method}, #{args.inspect}"
			self.add_element $1, args.first, options
		elsif found =  @elements.find{|e|e.name == method}
			found
		else
			super
		end
	end
	
	def browser
		B
	end

	def add_element(type, name, options={})
		@elements||=[]
		@elements << Element.new(self,type, name, options)
	end
end

class Element
	attr_accessor :page, :type, :name, :options
	def initialize(page,type, name, options)	
		assert page
		assert name
		assert type

		@page = page
		@type = type
		@name = name
		@options = options
	end

	def method_missing(method, *args)
		do_find_element.send(method,*args)
	end

	private
	def do_find_element
		@page.browser.find_element(type, options)
	end
end


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