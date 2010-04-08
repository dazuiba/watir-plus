#require "watir"
#c=Watir::IE.start "www.g.cn"
#c.xmlparser_document_object

require "nokogiri"
require "open-uri"
doc = Nokogiri::HTML(open('http://item.tbsandbox.com/item_detail.jhtml?item_id=9f1aa2b9f1196c8db3e0b4353f4f9d2d&x_id=db2'))
puts doc.css("#detail .key .skin .prop").first.tag_name

class A
	include Enumerable
	def initialize
		@a=[1,2,3]
	end

	def method_missing(method, *args)
		raise args.inspect
	end

	def each
		@a.each{|e|yield e}
	end
end

#A.new.sdf(1,2, :a=>1)