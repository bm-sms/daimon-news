class Site < ActiveRecord::Base
  has_many :categories, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :topics, dependent: :destroy
  has_many :hooks, dependent: :destroy
end
