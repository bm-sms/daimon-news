require 'test_helper'

class PostDecoratorTest < ActiveDecorator::TestCase

  def setup
    @post = ActiveDecorator::Decorator.instance.decorate(Post.new)
  end

  sub_test_case "thumbnail_iamge_tag" do
    test "no thumbnail" do
      assert_equal(%q(<img src="/dummy.png" alt="Dummy" />),
                   @post.thumbnail_image_tag)
    end

    test "w/ thumbnail_url" do
      @post.thumbnail_url = "http://example.com/thumbnail.png"
      assert_equal(%q(<img src="http://example.com/thumbnail.png" alt="Thumbnail" />),
                   @post.thumbnail_image_tag)
    end
  end
end
