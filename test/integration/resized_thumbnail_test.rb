require 'test_helper'

class ResizedThumbnailTest < ActionDispatch::IntegrationTest
  sub_test_case "not using resized thumbnail" do
    setup do
      post_data = create(
        :post,
        :whatever,
        title: "Hi"
      )
      switch_domain(post_data.site.fqdn)
    end

    test "not using resized thumbnail" do
      visit "/"
      assert_not_match(/resized_thumbnail.jpg/, first(".article-summary__thumbnail")["src"])
    end
  end

  sub_test_case "using resized thumbnail" do
    setup do
      site = create(:site, :resize_thumb)
      post_data = create(
        :post,
        :whatever,
        site: site,
        title: "Hi"
      )
      switch_domain(post_data.site.fqdn)
    end

    test "using resized thumbnail" do
      visit "/"
      assert_match(/resized_thumbnail.jpg/, first(".article-summary__thumbnail")["src"])
    end
  end
end
