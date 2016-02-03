require 'test_helper'

class MissingTemplateTest < ActionDispatch::IntegrationTest
  setup do
    @site = Site.create!(name: 'daimon-news', fqdn: 'www.example.com', js_url: '', css_url: '')

    Rails.application.env_config['action_dispatch.show_detailed_exceptions'] = false
    Rails.application.env_config['action_dispatch.show_exceptions'] = true
  end

  teardown do
    Rails.application.env_config['action_dispatch.show_detailed_exceptions'] = true
    Rails.application.env_config['action_dispatch.show_exceptions'] = false
  end

  sub_test_case "not found" do
    test "no extension" do
      visit '/foo'
      assert_equal 404, page.status_code
    end

    test "html" do
      visit '/foo.html'
      assert_equal 404, page.status_code
    end

    test "json" do
      visit '/foo.json'
      assert_equal 404, page.status_code
    end
  end
end
