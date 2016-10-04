class RedirectSerializer < ActiveModel::Serializer
  attributes :id, :request, :destination
end
