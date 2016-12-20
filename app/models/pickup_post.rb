class PickupPost < ActiveRecord::Base
  include Orderable

  belongs_to :site
  belongs_to :post

  validates :post_id, presence: true, uniqueness: {scope: :site_id}

  scope :published, -> { joins(:post).merge(Post.published) }

  before_validation :assign_default_order

  def siblings
    self.class.where(site_id: site_id)
  end
end
