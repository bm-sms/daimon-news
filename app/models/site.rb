class Site < ActiveRecord::Base
  has_many :categories
  has_many :posts
end
