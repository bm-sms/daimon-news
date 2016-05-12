class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :description

  has_many :posts
end
