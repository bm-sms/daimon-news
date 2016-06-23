class SerialSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :thumbnail_url
  meta do
    {
      posts_count: object.posts.published.count
    }
  end

  def thumbnail_url
    scope.image_url(object.thumbnail_url)
  end
end
