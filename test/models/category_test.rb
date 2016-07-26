require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  def setup
    site = create(:site)
    @categories = []
    @categories << create(:category, name: "Ruby", order: 1, site: site)
    @categories << create(:category, name: "Opal", order: 2, site: site)
    @categories << create(:category, name: "mruby", order: 3, site: site)
    @categories << create(:category, name: "JRuby", order: 4, site: site)
    @categories << create(:category, name: "Rubinius", order: 5, site: site)
  end

  def test_move_to_left_of
    @categories[4].move_to_left_of(@categories[3])
    expected = @categories.map(&:name).values_at(0, 1, 2, 4, 3)
    assert_equal(expected, Category.ordered.pluck(:name))
  end

  def test_move_to_left_of_shifted_2
    @categories[4].move_to_left_of(@categories[2])
    expected = @categories.map(&:name).values_at(0, 1, 4, 2, 3)
    assert_equal(expected, Category.ordered.pluck(:name))
  end

  def test_move_to_right_of
    @categories[0].move_to_right_of(@categories[1])
    expected = @categories.map(&:name).values_at(1, 0, 2, 3, 4)
    assert_equal(expected, Category.ordered.pluck(:name))
  end

  def test_move_to_right_of_shifted_2
    @categories[0].move_to_right_of(@categories[2])
    expected = @categories.map(&:name).values_at(1, 2, 0, 3, 4)
    assert_equal(expected, Category.ordered.pluck(:name))
  end
end
