class FixedPage < ActiveRecord::Base
  belongs_to :site

  validates :slug, format: /\A\w+\z/, uniqueness: {scope: :site_id}
end
