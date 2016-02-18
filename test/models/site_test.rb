require 'test_helper'

class SiteTest < ActiveSupport::TestCase
  setup do
    @default_locale = I18n.locale
    I18n.locale = :ja
    @site = Site.create!(name: "name",
                         js_url: "http://example.com/application.js",
                         css_url: "http://example.com/application.css")
    @post = create(:post, site: @site)
    Tempfile.open do |file|
      @site.images.create!(image: file)
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
      assert_equal(["を入力してください"], site.errors[:name])
    end

    test 'blank' do
      site = Site.create(name: "",
                         js_url: "http://example.com/application.js",
                         css_url: "http://example.com/application.css")
      assert_false(site.valid?)
      assert_equal(["を入力してください"], site.errors[:name])
    end
  end

  sub_test_case 'fqdn' do
    test 'blank' do
      site = Site.create(name: "site1",
                         fqdn: "",
                         js_url: "http://example.com/application.js",
                         css_url: "http://example.com/application.css")
      assert_false(site.valid?)
      assert_equal(["を入力してください"], site.errors[:fqdn])
    end

    test 'unique' do
      fqdn = "exapmle.com"
      Site.create(name: "site1",
                  fqdn: fqdn,
                  js_url: "http://example.com/application.js",
                  css_url: "http://example.com/application.css")
      site = Site.create(name: "site2",
                         fqdn: fqdn,
                         js_url: "http://example.com/application.js",
                         css_url: "http://example.com/application.css")
      assert_false(site.valid?)
      assert_equal(["はすでに存在します"], site.errors[:fqdn])
    end
  end
end
