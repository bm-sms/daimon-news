class PostSearchResultSet
  attr_accessor :posts
  attr_accessor :participants
  attr_accessor :categories

  def initialize
    @snippet = nil
  end

  def snippet(text, html_options = {})
    (@snippet ||= create_snippet(html_options)).execute(text)
  end

  private
  def create_snippet(html_options)
    open_tag = "<span class='#{html_options[:class]}'>"
    close_tag = '</span>'
    options = {
      :normalize => true,
      :width => 200,
      :html_escape => true,
    }
    @posts.expression.snippet([open_tag, close_tag], options)
  end
end
