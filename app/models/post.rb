class Post < ActiveRecord::Base
  has_many :credits, dependent: :destroy do
    def with_ordered
      eager_load(:role).order('credit_roles.order')
    end
  end

  belongs_to :site
  belongs_to :category

  validates :category_id, presence: true
  validates :body, presence: true
  validates :thumbnail, presence: true

  before_save :assign_public_id

  scope :published, -> { where('published_at <= ?', Time.current) }
  scope :order_by_recently, -> { order(:published_at => :desc, :id => :asc) }

  accepts_nested_attributes_for :credits, reject_if: :all_blank, allow_destroy: true

  paginates_per 20

  mount_uploader :thumbnail, ImageUploader

  class << self
    def order_by_ids(ids)
      return all if ids.empty?
      sql = ["CASE"]
      ids.each_with_index do |id, i|
        sql << "WHEN #{quoted_table_name}.id='#{id}' THEN #{i}"
      end
      sql << "END"
      order(sql.join(' '))
    end
  end

  def pages
    @pages ||= Page.pages_for(body)
  end

  def related_posts
    searcher = PostSearcher.new
    ids = searcher.related_post_ids(self)
    Post.published.where(id: ids)
  end

  def next_post
    @next_post ||= around_posts_candidates
      .order(:id => :desc)
      .where('id > ?', id)
      .first
  end

  def previous_post
    @previous_post ||= around_posts_candidates
      .order(:id)
      .where('id < ?', id)
      .first
  end

  def to_param
    public_id.to_s
  end

  private

  def around_posts_candidates
    site.posts.published.order_by_recently
  end

  def assign_public_id
    self.public_id ||= (self.class.maximum(:public_id) || 0) + 1
  end
end
