module Order
  extend ActiveSupport::Concern

  included do
    scope :ordered, -> { order(:order) }
    validates :order, numericality: {only_integer: true}
  end

  module ClassMethods
    def swap_order(record1, record2)
      transaction do
        record1_order = record1.order
        record2_order = record2.order

        # Insert null to avoid unique constraint
        record1.update_column(:order, nil)
        record2.update_column(:order, record1_order)
        record1.update_column(:order, record2_order)
      end
    end
  end

  def siblings
    self.class.where(site_id: site_id)
  end

  def higher_item
    siblings.where('"order" < ?', order).ordered.last
  end

  def lower_item
    siblings.where('"order" > ?', order).ordered.first
  end

  def move_to(direction:, target:)
    return false unless valid_target?(direction: direction, target: target)

    self.class.swap_order(self, target)

    true
  end

  private

  def valid_target?(direction:, target:)
    (direction == "higher" && higher_item == target) || (direction == "lower" && lower_item == target)
  end
end
