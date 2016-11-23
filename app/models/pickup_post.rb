class PickupPost < ActiveRecord::Base
  include Order

  belongs_to :site
  belongs_to :post

  validates :post_id, presence: true, uniqueness: {scope: :site_id}

  before_validation do
    self.order = (self.class.maximum(:order) || 0) + 1 if !order
  end
end
