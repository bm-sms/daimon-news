class Post < ActiveRecord::Base
  extend OrderAsSpecified

  attr_accessor :snippet

  has_many :credits, dependent: :destroy do
    def with_ordered
      order(:order)
    end
  end

  belongs_to :site
  belongs_to :serial
  has_many :categorizations, -> { ordered }, dependent: :destroy
  has_many :categories, through: :categorizations

  validates :public_id, uniqueness: {scope: :site_id}
  validates :body, presence: true
  validates :thumbnail, presence: true
  validates :categorizations, presence: true
  validates_with PostCategoryValidator

  before_save :assign_public_id

  scope :published, -> { where("published_at <= ?", Time.current) }
  scope :order_by_recent, -> { order(published_at: :desc, id: :asc) }
  scope :categorized_by, lambda {|category|
    category_ids = category.has_children? ? category.subtree_ids : [category.id]
    joins(:categories).where("categories.id" => category_ids).uniq
  }

  accepts_nested_attributes_for :credits, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :categorizations, reject_if: :all_blank, allow_destroy: true

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

  def participant_role(participant)
    credits.find {|credit| credit.participant == participant }.role
  end

  def main_category
    categories.first!
  end

  private

  def assign_public_id
    self.public_id ||= (self.class.maximum(:public_id) || 0) + 1
  end
end
