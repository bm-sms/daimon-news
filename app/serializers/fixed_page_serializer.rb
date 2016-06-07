class FixedPageSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :slug
end
