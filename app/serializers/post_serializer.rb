class PostSerializer < ActiveModel::Serializer
  attributes(
    :id,
    :public_id,
    :title,
    :body,
    :created_at,
    :updated_at,
    :published_at,
    :post_url,
    :thumbnail_url,
    :snippet
  )

  belongs_to :serial
  has_many :categories
  has_many :related_posts

  def post_url
    scope.post_url(object.public_id)
  end

  def thumbnail_url
    scope.image_url(object.thumbnail_url)
  end
end
