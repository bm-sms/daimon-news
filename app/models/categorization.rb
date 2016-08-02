class Categorization < ActiveRecord::Base
  belongs_to :category
  belongs_to :post

  validates :category_id, presence: true
  validates :order, numericality: :only_integer

  scope :ordered, -> { order(:order) }
end
