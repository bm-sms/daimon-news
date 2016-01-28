require 'test_helper'

class PostTest < ActiveSupport::TestCase
  setup do
    @default_locale = I18n.locale
    I18n.locale = :ja
    @site = Site.create!(name: "name",
                         js_url: "http://example.com/application.js",
                         css_url: "http://example.com/application.css")
  end

  teardown do
    I18n.locale = @default_locale
  end

  sub_test_case 'order' do
    data({
      null: nil,
      blank: "",
      alphabet: "a",
    })
    def test_only_integer(data)
      category = @site.categories.create(
        name:        'category 1',
        description: 'category 1',
        slug:        'category1',
        order:       data
      )
      assert_false(category.valid?)
      assert_equal(["は数値で入力してください"], category.errors[:order])
    end
  end
end
