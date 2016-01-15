require 'test_helper'

class SiteTest < ActiveSupport::TestCase
  setup do
    @default_locale = I18n.locale
    I18n.locale = :en
    @site = Site.create!(name: "name",
                         js_url: "http://example.com/application.js",
                         css_url: "http://example.com/application.css")
    @post = @site.posts.create!(title: "title", body: "body")
    Tempfile.open do |file|
      @post.images.create!(image: file)
    end
  end

  teardown do
    I18n.locale = @default_locale
  end

  test 'destroy site' do
    assert_equal(1, Site.count)
    assert_equal(1, Post.count)
    assert_equal(1, Image.count)
    @site.destroy
    assert_equal(0, Site.count)
    assert_equal(0, Post.count)
    assert_equal(0, Image.count)
  end

  sub_test_case 'name' do
    test 'null' do
      site = Site.create(js_url: "http://example.com/application.js",
                         css_url: "http://example.com/application.css")
      assert_false(site.valid?)
      assert_equal("can't be blank", site.errors[:name][0])
    end

    test 'blank' do
      site = Site.create(name: "",
                         js_url: "http://example.com/application.js",
                         css_url: "http://example.com/application.css")
      assert_false(site.valid?)
      assert_equal("can't be blank", site.errors[:name][0])
    end
  end
end
