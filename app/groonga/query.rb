class Query
  include ActiveModel::Model
  attr_accessor :keywords
  attr_accessor :site_id

  def present?
    keywords.present?
  end
end
