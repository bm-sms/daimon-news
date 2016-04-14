class Site < ActiveRecord::Base
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
  validate :validate_category_title_format

  mount_uploader :logo_image, ImageUploader
  mount_uploader :favicon_image, ImageUploader
  mount_uploader :mobile_favicon_image, ImageUploader

  def credit_enabled?
    participants.exists? && credit_roles.exists?
  end

  def validate_category_title_format
    if /%{(?!name)}/ =~ category_title_format ||
         /%[^{]/ =~ category_title_format
      errors.add(:category_title_format, "Invalid format")
    end
  end
end
