class Category < ActiveRecord::Base
  include Orderable

  belongs_to :site
  has_many :categorizations, dependent: :destroy
  has_many :posts, through: :categorizations

  has_ancestry

  validates :slug, format: /\A\w+\z/, uniqueness: {scope: :site_id}

  # For PostgreSQL, doesn't work on MySQL
  # See https://github.com/stefankroes/ancestry/pull/238
  scope :leaves, -> { joins("LEFT JOIN #{quoted_table_name} AS c ON c.#{ancestry_column} = CAST(#{quoted_table_name}.id AS text) OR c.#{ancestry_column} = #{quoted_table_name}.#{ancestry_column} || '/' || #{quoted_table_name}.id").group("#{quoted_table_name}.id").having("COUNT(c.id) = 0").order("#{quoted_table_name}.#{ancestry_column} NULLS FIRST", :order) }
  scope :parental, lambda {|category|
    categories = includes(:posts).where("posts.id" => nil).order("#{quoted_table_name}.#{ancestry_column} NULLS FIRST", :order)
    categories = categories.where.not(id: category.subtree.ids) if category.persisted?

    categories
  }

  before_validation do
    assign_default_order if !order || ancestry_changed?
  end

  def siblings
    super.where(site_id: site_id)
  end

  # This is stolen from ancestry master HEAD: https://github.com/stefankroes/ancestry/blob/f8a75226a9d18696f29c440bac6995ab1efc24b4/lib/ancestry/instance_methods.rb#L193-L195
  # This it not included in v2.1.0 (It is current latest release)
  def root_of?(node)
    id == node.root_id
  end

  def full_name
    (ancestors.pluck(:name) + [name]).join("/")
  end

  def post_count
    if has_children?
      ids = subtree.flat_map do |category|
        category.posts.published.pluck(:id)
      end
      ids.uniq.size
    else
      posts.published.count
    end
  end
end
