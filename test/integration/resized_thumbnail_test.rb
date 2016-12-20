require 'test_helper'

class ResizedThumbnailTest < ActionDispatch::IntegrationTest
  setup do
    @post = create(
      :post,
      :whatever,
      title: "Hi"
    )
    switch_domain(@post.site.fqdn)
  end

  test "not using resized thumbnail" do
    visit "/"
    assert_equal(first(".article-summary__thumbnail")["src"], "/uploads/post/thumbnail/1/thumbnail.jpg")
  end

  test "using resized thumbnail" do
    visit "/"
    assert_equal(first(".article-summary__thumbnail")["src"], "/uploads/post/thumbnail/2/resized_thumbnail.jpg")
  end
end
