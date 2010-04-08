class PageChecker
  attr_accessor :page
  def initialize(page)
    @page = page
  end

  def attrs_ok!
    page.attrs.each{|k,v|
      assert !page.browser.find_html_element(v).text.blank?, "#{k} is not exists!"
    }    
  end

end