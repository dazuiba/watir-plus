class PageFinder
	def self.find(pages, url)
		bingo = pages.find do |page|
			same_page?(page, url)
		end
		assert bingo, "没有找到此URL对应的page url:#{url}"
		bingo
	end

	def	self.same_page?(page, url)
		uri = URI.parse(url)
		url_host = uri.host.split(".").first
		url_path = uri.path

    return false if (url_host != page.host)
    
    if pt = page.reg_path
      return Regexp.new(pt) =~ url_path
    else
      return page.path == url_path
    end    
	end

end