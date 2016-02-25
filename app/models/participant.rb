class Participant < ActiveRecord::Base
  has_many :credits, dependent: :destroy

  belongs_to :site
end
