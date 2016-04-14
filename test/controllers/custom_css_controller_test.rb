require "test_helper"

class CustomCssControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @request.env["devise.mapping"] = Devise.mappings[:user]

    sign_in create(:user, :admin)
  end

  test "show should render css with Site#base_hue" do
    site = create(:site, base_hue: 120)
    get :show, fqdn: site.fqdn, digest: "some-values"

    assert_response(:success)
    assert_match(".category{", @response.body)
  end

  test "show should redirect to default css URL without Site#base_hue" do
    site = create(:site, base_hue: nil)
    get :show, fqdn: site.fqdn, digest: "some-values"

    assert_redirected_to(%r{/assets/themes/default/application-[a-f\d]+\.js$})
  end

  test "show should redirect custom css URL with Site#css_url" do
    site = create(:site, css_url: "http://example.com/test.css", base_hue: 200)
    get :show, fqdn: site.fqdn, digest: "some-values"

    assert_redirected_to("http://example.com/test.css")
  end
end
