#require "watir"
#c=Watir::IE.start "www.g.cn"
#c.xmlparser_document_object

class A
	include Enumerable
	def initialize
		@a=[1,2,3]
	end
	def each
		@a.each{|e|yield e}
	end
end

A.new.size