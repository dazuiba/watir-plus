Tiny[:domain] = "tbsandbox.com"
Tiny.create_page :login_page do|page|
  page.host = "login"
  page.path = "/member/login.jhtml"
  page.add_text_field :username, :kv=>"name:TPL_username"
  page.add_text_field :password, :kv=>"name:TPL_password"
  page.add_button :login_submit, :xpath=>"div[@class='login-submit']/button"
end

Tiny.create_page :itaobao_page do|page|
  page.host = "i"
  page.path = "/my_taobao.htm"
end


Tiny.create_page :search_page do|page|
  page.host = "search"
  page.path = "/search"
  page.add_text_field :search, :kv=>"id:title"
  page.add_text_field :search, :kv=>"id:title"

	page.create_module :list, : do|list|
		list.
	end
end

