class Category < ActiveRecord::Base
  belongs_to :site
  has_many :posts

  validates :slug, format: /\A\w+\z/, uniqueness: {scope: :site_id}
end
