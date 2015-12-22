class Post < ActiveRecord::Base
  belongs_to :site
  belongs_to :category

  scope :published, -> { where('published_at <= ?', Time.current) }
  scope :order_by_recently, -> { order(:published_at => :desc) }

  paginates_per 20

  def pages
    @pages ||= Page.pages_for(body)
  end
end
