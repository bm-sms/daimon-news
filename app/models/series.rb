class Series < ActiveRecord::Base
  belongs_to :site
  has_many :posts, dependent: :nullify
end
