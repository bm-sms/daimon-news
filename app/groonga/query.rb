class Query
  include ActiveModel::Model
  attr_accessor :keywords
  attr_accessor :site_id
  attr_accessor :participant_id

  def present?
    keywords.present? ||
      participant_id.present?
  end

  def params(add: {}, remove: [])
    names = [
      :keywords,
      :site_id,
      :participant_id,
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
