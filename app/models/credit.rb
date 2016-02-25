class Credit < ActiveRecord::Base
  belongs_to :post
  belongs_to :participant
  belongs_to :credit_role
end
