class CreditRole < ActiveRecord::Base
  has_many :credites, dependent: :destroy

  belongs_to :site
end
