class SerialSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :thumbnail_url

  has_many :posts
end
