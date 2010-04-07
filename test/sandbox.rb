require '../lib/tiny'
Tiny[:domain] = "tbsandbox.com"

Tiny.create_page :login_page do|page|
  page.host = "login"
  page.path = "member/login.jhtml"
  page.add_text_field :username, :kv=>"name:TPL_username"
  page.add_text_field :password, :kv=>"name:TPL_password"
  page.add_button :login_submit, :xpath=>"div[@class='login-submit']/button"
end

Tiny.create_page :itaobao_page do|page|
  page.host = "i"
  page.path = "my_taobao.htm"
end




















Tiny.test "用户登录  没有特殊要求" do
  Tiny.goto :host=>"login", :path=>"member/login.jhtml", :params=>"login_type=3"  do|the_page|
    the_page.page_should_be? :login_page
    
    tpl = the_page.create_template :taobao_login do |page, args|
      page.username.set args[:username]
      page.password.set args[:password]
      page.login_submit.click
    end
    
    tpl.try(:username=>"tam_buy",:password=>"wrong") do
      the_page.page_should_be? :login_page

    end

    tpl.try(:username=>"wrong",:password=>"tam1234") do
      the_page.page_should_be? :login_page
    end

    tpl.try(:username=>"tam_buy",:password=>"tam1234") do
      the_page.page_should_be? :itaobao_page
    end
  end
end


Tiny.test " 搜索商品  要求能够显示商品列表，确保有多余一个商品显示出来，并且校验显示的列是有值的" do
  

end




#         显示商品详情 显示商品的基本信息(价格，快递费，名称，宝贝详情，评价详情，成交记录，掌柜信息，对于旺铺，要能够显示店铺内分类)
#         拍下商品  能够进入到付款页面
#         店铺浏览商品  显示店铺内的宝贝，掌柜信息，宝贝分类
#         进入我的淘宝
#         卖家修改价格 能够通过我的淘宝进入到已卖出，并且显示已卖出宝贝，以及这个宝贝的没列的信息
#         付款  能够通过我的淘宝进入到已买到，并且显示已买到宝贝，以及这个宝贝的没列的信息
#         添加商品到购物车
#         显示购物车 显示购物车中的宝贝，并且正确显示宝贝的每列信息
#         购物车付款 能够在购物车页面进入到购买页面，并拍下宝贝
#         查看卖家评价 能够显示卖家的评价，包括总体评价和评价的列表
