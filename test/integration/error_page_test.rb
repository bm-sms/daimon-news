require "test_helper"

class ErrorPageTest < ActionDispatch::IntegrationTest
  setup do
    @site = create(:site)
    switch_domain(@site.fqdn)
  end

  sub_test_case "render 404" do
    setup do
      any_instance_of(ApplicationController) do |klass|
        stub(klass).current_site { raise ActiveRecord::RecordNotFound }
      end
    end

    attribute :allow_rescue, true
    test "no extension" do
      visit "/foo"
      assert_equal 404, page.status_code
      assert_equal "Hello! my name is 404 | #{@site.name}", page.title
    end

    attribute :allow_rescue, true
    test "html" do
      visit "/foo.html"
      assert_equal 404, page.status_code
      assert_equal "Hello! my name is 404 | #{@site.name}", page.title
    end

    attribute :allow_rescue, true
    test "json" do
      visit "/foo.json"
      assert_equal 404, page.status_code
      assert_equal "Hello! my name is 404 | #{@site.name}", page.title
    end
  end

  attribute :allow_rescue, true
  test "render 422" do
    any_instance_of(ApplicationController) do |klass|
      stub(klass).current_site { raise ActiveRecord::RecordNotSaved, "not saved" }
    end

    visit "/"

    assert_equal 422, page.status_code
    assert_equal "ページが表示できません | #{@site.name}", page.title
  end

  attribute :allow_rescue, true
  test "render 500" do
    any_instance_of(ApplicationController) do |klass|
      stub(klass).current_site { raise }
    end

    visit "/"

    assert_equal 500, page.status_code
    assert_equal "サーバーエラー | #{@site.name}", page.title
  end
end
