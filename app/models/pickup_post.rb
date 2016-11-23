class PickupPost < ActiveRecord::Base
  include Orderable

  belongs_to :site
  belongs_to :post

  validates :post_id, presence: true, uniqueness: {scope: :site_id}

  before_validation do
    assign_default_order
  end

  def siblings
    self.class.where(site_id: site_id)
  end
end
