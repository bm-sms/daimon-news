class Credit < ActiveRecord::Base
  belongs_to :post
  belongs_to :participant
  belongs_to :role, foreign_key: :credit_role_id, class_name: "CreditRole"

  validates :participant_id, presence: true
  validates :credit_role_id, presence: true

  before_save :setup_order

  private

  def setup_order
    self.order ||= (post.credits.map(&:order).compact.max || 0) + 1
  end
end
