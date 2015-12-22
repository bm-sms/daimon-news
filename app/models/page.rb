class Page
  SEPARATOR = '<!--nextpage-->'.freeze

  class << self
    def pages_for(text)
      text.split(SEPARATOR).map do |t|
        new(t)
      end
    end
  end

  attr_reader :body

  def initialize(body)
    @body = body
  end
end
