class Editor::PostSearchQuery
  include ActiveModel::Model
  attr_accessor :public_id
  attr_accessor :title
  attr_accessor :category_id
  attr_accessor :site_id
end
