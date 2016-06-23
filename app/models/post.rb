class Post < ActiveRecord::Base
  attr_accessor :snippet

  has_many :credits, dependent: :destroy do
    def with_ordered
      order(:order)
    end
  end

  belongs_to :site
  belongs_to :category
  belongs_to :serial

  validates :public_id, uniqueness: { scope: :site_id }
  validates :category_id, presence: true
  validates :body, presence: true
  validates :thumbnail, presence: true

  before_save :assign_public_id

  scope :published, -> { where("published_at <= ?", Time.current) }
  scope :order_by_recent, -> { order(published_at: :desc, id: :asc) }

  accepts_nested_attributes_for :credits, reject_if: :all_blank, allow_destroy: true

  paginates_per 20

  mount_uploader :thumbnail, ImageUploader

  def pages
    @pages ||= Page.pages_for(body)
  end

  def related_posts
    searcher = PostSearcher.new
    ids = searcher.related_post_ids(self)
    Post.published.where(id: ids).order_by_recent
  end

  def to_param
    public_id.to_s
  end

  private

  def assign_public_id
    self.public_id ||= (self.class.maximum(:public_id) || 0) + 1
  end
end
