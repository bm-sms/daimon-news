class Category < ActiveRecord::Base
  belongs_to :site
  has_many :posts

  has_ancestry

  validates :slug, format: /\A\w+\z/, uniqueness: {scope: :site_id}
  validates :order, numericality: {only_integer: true}

  scope :ordered, -> { order(:order) }
  # For PostgreSQL, doesn't work on MySQL
  # See https://github.com/stefankroes/ancestry/pull/238
  scope :leaves, -> { joins("LEFT JOIN #{quoted_table_name} AS c ON c.#{ancestry_column} = CAST(#{quoted_table_name}.id AS text) OR c.#{ancestry_column} = #{quoted_table_name}.#{ancestry_column} || '/' || #{quoted_table_name}.id").group("#{quoted_table_name}.id").having("COUNT(c.id) = 0").order("#{quoted_table_name}.#{ancestry_column} NULLS FIRST", :order) }
  scope :parental, lambda {|category|
    categories = includes(:posts).where("posts.id" => nil).order("#{quoted_table_name}.#{ancestry_column} NULLS FIRST", :order)
    categories = categories.where.not(id: category.subtree.select(:id).to_sql) if category.persisted?

    categories
  }

  before_validation do
    self.order = (siblings.maximum(:order) || 0) + 1 if !order || ancestry_changed?
  end

  class << self
    def swap_order(cate1, cate2)
      transaction do
        cate1_order = cate1.order
        cate2_order = cate2.order

        # Insert null to avoid unique constraint
        cate1.update_column(:order, nil)
        cate2.update_column(:order, cate1_order)
        cate1.update_column(:order, cate2_order)
      end
    end
  end

  def full_name
    (ancestors.pluck(:name) + [name]).join("/")
  end

  def post_count
    if has_children?
      # Use `to_a` to call `Enumerable#sum` here.
      # We can remove `to_a` after Rails 5. http://api.rubyonrails.org/classes/ActiveRecord/Calculations.html#method-i-sum
      children.to_a.sum {|child| child.posts.published.count }
    else
      posts.published.count
    end
  end

  def higher_item
    siblings.where('"order" < ?', order).ordered.last
  end

  def lower_item
    siblings.where('"order" > ?', order).ordered.first
  end

  def move_to(direction:, target:)
    return false unless valid_target?(direction: direction, target: target)

    Category.swap_order(self, target)

    true
  end

  private

  def valid_target?(direction:, target:)
    (direction == "higher" && higher_item == target) || (direction == "lower" && lower_item == target)
  end
end
