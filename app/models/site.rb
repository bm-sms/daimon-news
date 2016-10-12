class Site < ActiveRecord::Base
  include CustomCssSupport

  VALID_FORMAT_KEYS = ["category_name"]

  has_many :categories, dependent: :destroy
  has_many :serials, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :fixed_pages, dependent: :destroy
  has_many :links, dependent: :destroy
  has_many :redirect_rules, dependent: :destroy
  has_many :images, dependent: :destroy
  has_many :participants, dependent: :destroy
  has_many :credit_roles, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :editors, through: :memberships, source: :user

  validates :name, presence: true
  validates :fqdn, presence: true, uniqueness: true
  validate :validate_category_title_format
  validate :redirect_loop

  mount_uploader :logo_image, ImageUploader
  mount_uploader :favicon_image, ImageUploader
  mount_uploader :mobile_favicon_image, ImageUploader
  mount_uploader :custom_hue_css, AssetUploader

  accepts_nested_attributes_for :redirect_rules, allow_destroy: true

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

  def redirect_loop
    redirect_loop = redirect_rules.find do |redirect_rule|
      redirect_rules.find do |item|
        redirect_rule.destination == item.request_path && redirect_rule.request_path == item.destination
      end
    end
    errors.add(:redirect_rules, I18n.t("activerecord.errors.models.redirect_rule.redirect_loop")) if redirect_loop
  end
end
