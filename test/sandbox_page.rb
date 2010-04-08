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
	page.create_module :result, "#list:content" do|list|
		list.add_collection :list_items, ".list-item" do |list_item|
			list_item.add_links(:title_link, ".summary a")
		end
	end
end

WP.create_page :error_page do|page|
  page.host = "www"
  page.path = "/home/error.php"
end

