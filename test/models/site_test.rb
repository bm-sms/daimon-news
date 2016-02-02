require 'test_helper'

class SiteTest < ActiveSupport::TestCase
  setup do
    @site = Site.create!(name: "name",
                         js_url: "http://example.com/application.js",
                         css_url: "http://example.com/application.css")
    @post = @site.posts.create!(title: "title", body: "body")
    Tempfile.open do |file|
      @site.images.create!(image: file)
    end
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
end
