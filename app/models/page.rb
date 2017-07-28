class Page
  SEPARATOR = "<!--nextpage-->".freeze

  class << self
    def pages_for(text)
      Kaminari.paginate_array([new(text)])
    end
  end

  attr_reader :body

  def initialize(body)
    @body = body
  end
end
