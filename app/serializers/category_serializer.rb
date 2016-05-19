class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :description, :order
end
