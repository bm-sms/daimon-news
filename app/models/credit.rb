class Credit < ActiveRecord::Base
  belongs_to :post
  belongs_to :participant
  belongs_to :credit_role

  validates :post_id, presence: true
  validates :participant_id, presence: true
  validates :credit_role_id, presence: true
end
