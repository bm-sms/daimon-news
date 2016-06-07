class SerialSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :thumbnail_url

  has_many :posts

  def thumbnail_url
    scope.image_url(object.thumbnail_url)
  end
end
