class Page
  SEPARATOR = "<!--nextpage-->".freeze

  class << self
    def pages_for(text)
      pages = text.split(SEPARATOR).map {|t| new(t) }

      Kaminari.paginate_array(pages)
    end
  end

  attr_reader :body

  def initialize(body)
    @body = body
  end
end
