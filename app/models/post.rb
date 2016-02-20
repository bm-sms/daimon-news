class Post < ActiveRecord::Base
  has_many :credits, dependent: :destroy do
    def with_ordered
      eager_load(:role).order('credit_roles.order')
    end
  end

  belongs_to :site
  belongs_to :category

  validates :body, presence: true
  validates :thumbnail, presence: true

  before_save :assign_public_id

  after_save do |post|
    indexer = PostIndexer.new
    indexer.add(post)
  end

  after_destroy do |post|
    indexer = PostIndexer.new
    indexer.remove(post)
  end

  scope :published, -> { where('published_at <= ?', Time.current) }
  scope :order_by_recently, -> { order(:published_at => :desc, :id => :asc) }

  accepts_nested_attributes_for :credits, reject_if: :all_blank, allow_destroy: true

  paginates_per 20

  mount_uploader :thumbnail, ImageUploader

  def pages
    @pages ||= Page.pages_for(body)
  end

  def related_posts
    maximum_id = Post.published.maximum(:id)

    Post.published.where(category: category).order("(id - #{id} + #{maximum_id} - 1) % #{maximum_id}").limit(9) # XXX 同じカテゴリの中から適当に返している
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
