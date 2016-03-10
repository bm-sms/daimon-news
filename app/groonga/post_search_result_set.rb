class PostSearchResultSet
  attr_accessor :posts
  attr_accessor :participants
  attr_accessor :categories

  def initialize
    @snippet = nil
  end

  def snippet(text)
    (@snippet ||= create_snippet).execute(text)
  end

  private
  def create_snippet
    open_tag = '<span class="keyword">'
    close_tag = '</span>'
    options = {
      :normalize => true,
      :width => 200,
      :html_escape => true,
    }
    @posts.expression.snippet([open_tag, close_tag], options)
  end
end
