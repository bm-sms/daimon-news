require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  sub_test_case ".swap_order" do
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

  sub_test_case "#siblings" do
    def setup
      site1 = create(:site)
      site2 = create(:site)
      @categories = []
      @categories << create(:category, name: "Ruby", site: site1)
      @categories << create(:category, name: "Opal", site: site2)
    end

    def test_siblings_not_include_another_sites_category
      assert_not_include(@categories[0].siblings, @categories[1])
      assert_not_include(@categories[0].sibling_ids, @categories[1].id)
      assert_not(@categories[0].has_siblings?)
    end
  end
end
