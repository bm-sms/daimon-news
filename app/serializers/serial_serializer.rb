class SerialSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :thumbnail_url

  def thumbnail_url
    scope.image_url(object.thumbnail_url)
  end
end
