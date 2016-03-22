class PostSearchResultSet
  attr_reader :site

  def initialize(groonga_posts:, site:, query:, page:)
    @groonga_posts = groonga_posts
    @site = site
    @query = query
    @page = page

    @snippet = nil
    @posts = nil
  end

  def keywords
    @query.keywords
  end

  def posts
    @posts ||= @site.posts.includes(credits: [:participant]).published.where(id: post_ids).order_by_ids(post_ids)
  end

  def post_ids
    @post_ids ||= Kaminari.paginate_array(searched_post_ids).page(@page).per(50)
  end

  def snippet(text, html_options = {})
    (@snippet ||= create_snippet(html_options)).execute(text)
  end

  private

  def searched_post_ids
    @groonga_posts.map(&:_key)
  end

  def create_snippet(html_options)
    open_tag = "<span class='#{html_options[:class]}'>"
    close_tag = '</span>'
    options = {
      :normalize => true,
      :width => 200,
      :html_escape => true,
    }
    @groonga_posts.expression.snippet([open_tag, close_tag], options)
  end
end
