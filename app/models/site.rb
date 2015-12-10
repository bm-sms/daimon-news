class Site < ActiveRecord::Base
  has_many :categories
  has_many :posts
  has_many :fixed_pages
end
