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
    sub_test_case "when category has siblings" do
      def setup
        site1 = create(:site)
        site2 = create(:site)
        @categories = []
        @categories << create(:category, name: "Ruby",   site: site1)
        @categories << create(:category, name: "Opal",   site: site1)
        @categories << create(:category, name: "Python", site: site2)
      end

      def test_siblings_include_only_same_sites_categories
        assert_match_array(@categories[0..1], @categories[0].siblings)
        assert_match_array(@categories[0..1].map(&:id), @categories[0].sibling_ids)
        assert(@categories[0].has_siblings?)
      end
    end

    sub_test_case "when category doesn't have siblings" do
      def setup
        site1 = create(:site)
        site2 = create(:site)
        @categories = []
        @categories << create(:category, name: "Ruby",   site: site1)
        @categories << create(:category, name: "Python", site: site2)
      end

      def test_siblings_include_only_same_sites_categories
        assert_equal([@categories[0]], @categories[0].siblings)
        assert_equal([@categories[0].id], @categories[0].sibling_ids)
        assert_not(@categories[0].has_siblings?)
      end
    end
  end

  private

  def assert_match_array(array1, array2)
    assert_equal(array1.sort, array2.sort)
  end
end
