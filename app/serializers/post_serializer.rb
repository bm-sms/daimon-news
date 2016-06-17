class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :published_at, :thumbnail_url, :snippet

  belongs_to :category
  has_many :related_posts

  def thumbnail_url
    scope.image_url(object.thumbnail_url)
  end
end
