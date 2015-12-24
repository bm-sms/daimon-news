class Link < ActiveRecord::Base
  belongs_to :site

  validates :text,  presence: true
  validates :url,   presence: true
  validates :order, presence: true
end
