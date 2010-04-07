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




















Tiny.test "�û���¼  û������Ҫ��" do
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


Tiny.test " ������Ʒ  Ҫ���ܹ���ʾ��Ʒ�б�ȷ���ж���һ����Ʒ��ʾ����������У����ʾ��������ֵ��" do
  

end




#         ��ʾ��Ʒ���� ��ʾ��Ʒ�Ļ�����Ϣ(�۸񣬿�ݷѣ����ƣ��������飬�������飬�ɽ���¼���ƹ���Ϣ���������̣�Ҫ�ܹ���ʾ�����ڷ���)
#         ������Ʒ  �ܹ����뵽����ҳ��
#         ���������Ʒ  ��ʾ�����ڵı������ƹ���Ϣ����������
#         �����ҵ��Ա�
#         �����޸ļ۸� �ܹ�ͨ���ҵ��Ա����뵽��������������ʾ�������������Լ����������û�е���Ϣ
#         ����  �ܹ�ͨ���ҵ��Ա����뵽���򵽣�������ʾ���򵽱������Լ����������û�е���Ϣ
#         �����Ʒ�����ﳵ
#         ��ʾ���ﳵ ��ʾ���ﳵ�еı�����������ȷ��ʾ������ÿ����Ϣ
#         ���ﳵ���� �ܹ��ڹ��ﳵҳ����뵽����ҳ�棬�����±���
#         �鿴�������� �ܹ���ʾ���ҵ����ۣ������������ۺ����۵��б�
