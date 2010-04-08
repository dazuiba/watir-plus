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