class Post < ActiveRecord::Base
  belongs_to :site
  belongs_to :category

  has_many :images, dependent: :destroy
  accepts_nested_attributes_for :images, allow_destroy: true

  mount_uploader :thumbnail_image, ThumbnailImageUploader

  scope :published, -> { where('published_at <= ?', Time.current) }
  scope :order_by_recently, -> { order(:published_at => :desc, :id => :asc) }

  paginates_per 20

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

  private

  def around_posts_candidates
    site.posts.published.order_by_recently
  end
end
