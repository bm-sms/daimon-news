class Post < ActiveRecord::Base
  belongs_to :site
  belongs_to :category
  belongs_to :author

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

  paginates_per 20

  mount_uploader :thumbnail, ImageUploader

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
