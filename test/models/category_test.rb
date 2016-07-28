require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  def setup
    site = create(:site)
    @categories = []
    @categories << create(:category, name: "Ruby", order: 1, site: site)
    @categories << create(:category, name: "Opal", order: 2, site: site)
  end

  def test_swap_order
    Category.swap_order(@categories[0], @categories[1])
    expected = @categories.map(&:name).values_at(1, 0)
    assert_equal(expected, Category.ordered.pluck(:name))
  end
end
