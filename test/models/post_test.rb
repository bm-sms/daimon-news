require "test_helper"

class PostTest < ActiveSupport::TestCase
  setup do
    @default_locale = I18n.locale
    I18n.locale = :ja
    @site = create(:site)
  end

  teardown do
    I18n.locale = @default_locale
  end

  sub_test_case "relation" do
    setup do
      category = create(:category, site: @site)
      role = create(:credit_role, site: @site)
      @participant = create(:participant, site: @site)
      post = create(:post, site: @site, categories: [category])
      post.credits.create!(participant: @participant, role: role, order: 1)
    end

    def test_destroy
      assert_equal(Site.count, 1)
      assert_equal(Category.count, 1)
      assert_equal(Participant.count, 1)
      assert_equal(Post.count, 1)
      assert_equal(Credit.count, 1)
      @participant.destroy
      assert_equal(Site.count, 1)
      assert_equal(Category.count, 1)
      assert_equal(Participant.count, 0)
      assert_equal(Post.count, 1)
      assert_equal(Credit.count, 0)
    end
  end

  sub_test_case "credits order" do
    setup do
      @post = create(:post, :whatever, site: @site)

      (1..3).to_a.reverse.each do |i|
        role = create(:credit_role, name: "Role: #{i}", site: @site, order: i)
        participant = create(:participant, name: "Participant: #{i}", site: @site)

        @post.credits.create!(participant: participant, role: role, order: i)
      end

      @credits = @post.credits.with_ordered
    end

    def test_roles_should_ordered_by_role_order
      assert_equal @credits.map(&:role).map(&:name), ["Role: 1", "Role: 2", "Role: 3"]
    end

    def test_participants_should_ordered_by_role_order
      assert_equal @credits.map(&:participant).map(&:name), ["Participant: 1", "Participant: 2", "Participant: 3"]
    end
  end

  sub_test_case "category" do
    setup do
      @parent_category = create(:category, site: @site)
      @child_category = create(:category, site: @site, parent: @parent_category)
    end

    test "validate_with PostCategoryValidator" do
      post = build(:post, categories: [@parent_category], site: @site)
      assert { !post.valid? }
      assert_equal(["子カテゴリを持つカテゴリ「#{@parent_category.full_name}」に記事を登録することはできません。"], post.errors[:categorizations])
    end
  end
end
