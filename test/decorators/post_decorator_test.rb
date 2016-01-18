require 'test_helper'

class PostDecoratorTest < ActiveSupport::TestCase

  def setup
    controller = Class.new(ApplicationController).new
    controller.request = ActionController::TestRequest.new
    ActiveDecorator::ViewContext.push(controller.view_context)
    @post = ActiveDecorator::Decorator.instance.decorate(Post.new)
  end

  sub_test_case "thumbnail_iamge_tag" do
    test "no thumbnail" do
      assert_equal(%q(<img src="/dummy.png" alt="Dummy" />),
                   @post.thumbnail_image_tag)
    end
  end
end
