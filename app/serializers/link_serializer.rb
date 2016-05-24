class LinkSerializer < ActiveModel::Serializer
  attributes :id, :text, :url, :order
end
