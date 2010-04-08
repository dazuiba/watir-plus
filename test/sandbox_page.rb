WP[:domain] = "taobao.com"
WP.create_page :login_page do|page|
  page.host = "login"
  page.path = "/member/login.jhtml"
  page.add_text_field :username, :kv=>"name:TPL_username"
  page.add_text_field :password, :kv=>"name:TPL_password"
  page.add_button :login_submit, :xpath=>"div[@class='login-submit']/button"
end

WP.create_page :itaobao_page do|page|
  page.host = "i"
  page.path = "/my_taobao.htm"
end


WP.create_page :search_page do|page|
  page.host = "search"
  page.path = "/search"
  page.add_text_field :search, :kv=>"id:title"
	page.create_module :result, ".list-item" do|list|
		list.add_links :title_links, ".summary a"
	end
end

WP.create_page :detail_page do|page|
  page.host = "item"
  page.reg_path = "/item_detail(.*)\.jhtml"
  page.add_text_field :search, :kv=>"id:title"
  page.add_attr(:price,"#J_StrPrice")#价格
  page.add_attr(:shipping_cost,"#ShippingCost em")#快递费
  page.add_attr(:title,"#detail .detail-hd h3")#名称
  page.add_attr(:detail,"#attributes")#宝贝详情
  page.add_attr(:reviews,"#reviews")#评价详情
  page.add_attr(:deal_record,"#deal-record")#成交记录
  page.add_attr(:shop_info,".shop-info")#掌柜信息
  page.add_link(:buy_link,"#J_LinkBuy")#立即购买
  page.create_module :select_prop, "#detail .key .skin .prop" do |prop|
    def prop.click_all_first
      self.html_elements.each{|e|WP.to_watir(e.css("a").first).click}
    end
  end
  #TODO 对于旺铺，要能够显示店铺内分类
	page.create_module :result, ".list-item" do|list|
		list.add_links :title_links, ".summary a"
	end
end

WP.create_page :buy_now_page do|page|
  page.host = "buy"
  page.path = "/auction/buy_now.jhtml"
  page.add_radios(:shipping_option_radios,"input[name='_shipping_option']")#递送方式
  page.add_button(:submit_button, "#performSubmit")
end

WP.create_page :mockalipay do|page|
  page.host = "alipaymock"
  page.reg_path = "/mockalipay/batch_payment"
  page.add_text_field :money,  "input[name=money]"
  page.add_button :submit_button, "input[type=submit]"
end

WP.create_page :error_page do|page|
  page.host = "www"
  page.path = "/home/error.php"
end

