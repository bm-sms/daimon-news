class Serial < ActiveRecord::Base
  belongs_to :site
  has_many :posts, dependent: :nullify

  validates :slug, format: /\A\w+\z/, uniqueness: {scope: :site_id}
end
