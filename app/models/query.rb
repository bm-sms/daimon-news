class Query
  include ActiveModel::Model
  attr_accessor :keywords
  attr_accessor :site_id
  attr_accessor :author_id

  def params(add: {}, remove: [])
    names = [
      :keywords,
      :site_id,
      :author_id,
    ]

    query = {}
    names.each do |name|
      next if remove.include?(name)
      value = add[name] || __send__(name)
      query[name] = value if value.present?
    end

    {query: query}
  end
end
