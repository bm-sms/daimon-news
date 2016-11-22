class PickupPost < ActiveRecord::Base
  belongs_to :site
  belongs_to :post

  validates :post_id, presence: true, uniqueness: {scope: :site_id}
  validates :order, numericality: {only_integer: true}

  scope :ordered, -> { order(:order) }

  before_validation do
    self.order = (PickupPost.maximum(:order) || 0) + 1 if !order
  end

  class << self
    def swap_order(post1, post2)
      transaction do
        post1_order = post1.order
        post2_order = post2.order

        # Insert null to avoid unique constraint
        post1.update_column(:order, nil)
        post2.update_column(:order, post1_order)
        post1.update_column(:order, post2_order)
      end
    end
  end

  def higher_item
    PickupPost.where('"order" < ?', order).ordered.last
  end

  def lower_item
    PickupPost.where('"order" > ?', order).ordered.first
  end

  def move_to(direction:, target:)
    return false unless valid_target?(direction: direction, target: target)

    PickupPost.swap_order(self, target)

    true
  end

  private

  def valid_target?(direction:, target:)
    (direction == "higher" && higher_item == target) || (direction == "lower" && lower_item == target)
  end
end
