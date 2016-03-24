class CreditRole < ActiveRecord::Base
  has_many :credits, dependent: :destroy

  belongs_to :site

  validates :name, presence: true, uniqueness: {scope: :site_id}
  validates :order, numericality: :only_integer
end
