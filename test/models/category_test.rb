require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  def setup
    site = create(:site)
    @categories = create_list(:category, 5, site: site)
  end

  def test_move_to_child_of
    @categories[4].move_to_child_of(@categories[0])
    @categories[3].move_to_child_of(@categories[0])
    assert_equal(@categories[0].id.to_s, @categories[4].ancestry)
    assert_equal(1, @categories[4].order)
    assert_equal(@categories[0].id.to_s, @categories[3].ancestry)
    assert_equal(2, @categories[3].order)
    @categories[3].move_to_child_of(@categories[4])
    assert_equal("#{@categories[0].id}/#{@categories[4].id}", @categories[3].ancestry)
    assert_equal(1, @categories[3].order)
  end

  def test_move_to_left_of
    @categories[4].move_to_left_of(@categories[3])
    expected = @categories.map(&:name).values_at(0, 1, 2, 4, 3)
    assert_equal(expected, Category.ordered.pluck(:name))
  end

  def test_move_to_left_of_2
    @categories[4].move_to_left_of(@categories[2])
    expected = @categories.map(&:name).values_at(0, 1, 4, 2, 3)
    assert_equal(expected, Category.ordered.pluck(:name))
  end

  def test_move_to_right_of
    @categories[0].move_to_right_of(@categories[1])
    expected = @categories.map(&:name).values_at(1, 0, 2, 3, 4)
    assert_equal(expected, Category.ordered.pluck(:name))
  end

  def test_move_to_right_of_2
    @categories[0].move_to_right_of(@categories[2])
    expected = @categories.map(&:name).values_at(1, 2, 0, 3, 4)
    assert_equal(expected, Category.ordered.pluck(:name))
  end
end
