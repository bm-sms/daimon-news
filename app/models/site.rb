class Site < ActiveRecord::Base
  VALID_FORMAT_KEYS = ["category_name"]

  has_many :categories, dependent: :destroy
  has_many :serials, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :fixed_pages, dependent: :destroy
  has_many :links, dependent: :destroy
  has_many :images, dependent: :destroy
  has_many :participants, dependent: :destroy
  has_many :credit_roles, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :editors, through: :memberships, source: :user

  validates :name, presence: true
  validates :fqdn, presence: true, uniqueness: true
  validates :base_hue, numericality: {
    greater_than_or_equal_to: 0,
    less_than: 360,
    allow_nil: true
  }
  validate :validate_category_title_format

  mount_uploader :logo_image, ImageUploader
  mount_uploader :favicon_image, ImageUploader
  mount_uploader :mobile_favicon_image, ImageUploader

  def credit_enabled?
    participants.exists? && credit_roles.exists?
  end

  def custom_css_available?
    base_hue? && !css_url?
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
