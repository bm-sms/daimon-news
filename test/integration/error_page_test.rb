require 'test_helper'

class ErrorPageTest < ActionDispatch::IntegrationTest
  setup do
    Site.create!(name: 'daimon-news', fqdn: 'www.example.com', js_url: '', css_url: '')

    Rails.application.env_config['action_dispatch.show_detailed_exceptions'] = false
    Rails.application.env_config['action_dispatch.show_exceptions'] = true
  end

  teardown do
    Rails.application.env_config['action_dispatch.show_detailed_exceptions'] = true
    Rails.application.env_config['action_dispatch.show_exceptions'] = false
  end

  test 'render 404' do
    any_instance_of(ApplicationController) do |klass|
      stub(klass).current_site { raise ActiveRecord::RecordNotFound }
    end

    visit '/'

    assert_equal 404, page.status_code
    assert_equal 'Hello! my name is 404 | daimon-news', page.title
  end

  test 'render 422' do
    any_instance_of(ApplicationController) do |klass|
      stub(klass).current_site { raise ActiveRecord::RecordNotSaved, 'not saved' }
    end

    visit '/'

    assert_equal 422, page.status_code
    assert_equal 'ページが表示できません | daimon-news', page.title
  end

  test 'render 500' do
    any_instance_of(ApplicationController) do |klass|
      stub(klass).current_site { raise }
    end

    visit '/'

    assert_equal 500, page.status_code
    assert_equal 'サーバーエラー | daimon-news', page.title
  end
end
