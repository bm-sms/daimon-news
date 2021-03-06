class Site < ActiveRecord::Base
  include CustomCssSupport

  VALID_FORMAT_KEYS = ["category_name"].freeze
  RANKING_SIZE_MAX = 20

  has_many :categories, dependent: :destroy
  has_many :serials, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :fixed_pages, dependent: :destroy
  has_many :links, dependent: :destroy
  has_many :redirect_rules, dependent: :destroy
  has_many :pickup_posts, dependent: :destroy
  has_many :popular_posts, dependent: :destroy
  has_many :top_fixed_posts, dependent: :destroy
  has_many :images, dependent: :destroy
  has_many :participants, dependent: :destroy
  has_many :credit_roles, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :editors, through: :memberships, source: :user

  validates :name, presence: true
  validates :fqdn, presence: true, uniqueness: true
  validates :ranking_size, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: RANKING_SIZE_MAX}
  validate :validate_category_title_format

  mount_uploader :logo_image, ImageUploader
  mount_uploader :favicon_image, ImageUploader
  mount_uploader :mobile_favicon_image, ImageUploader
  mount_uploader :custom_hue_css, AssetUploader

  def credit_enabled?
    participants.exists? && credit_roles.exists?
  end

  def public_participant_page_accessible?
    public_participant_page_enabled? && participants.having_published_posts.exists?
  end

  def posted_root_categories
    ids = categories.select(:id, :ancestry).joins(:categorizations).uniq.map {|c| c.root_id || c.id }.uniq
    categories.where(id: ids)
  end

  private

  def validate_category_title_format
    return if category_title_format.blank?
    category_title_format.scan(/%{(\w+?)}/) do |match|
      unless VALID_FORMAT_KEYS.include?(match[0])
        errors.add(:category_title_format, :invalid)
      end
    end
    category_title_format.scan(/%([^{% ])/) do
      errors.add(:category_title_format, :invalid)
    end
  end
end
