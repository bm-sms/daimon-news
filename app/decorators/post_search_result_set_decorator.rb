module PostSearchResultSetDecorator
  def canonical_params
    {query: {keywords: keywords}, page: paginator.current_page}
  end

  def canonical_url
    url_for(canonical_params.merge(only_path: false))
  end

  def message
    if posts.empty?
      "「#{keywords}」を含む記事は見つかりませんでした。"
    elsif paginator.total_pages > 1
      "「#{keywords}」を含む記事は#{paginator.total_count}件見つかりました。(#{page_entries_info})"
    else
      "「#{keywords}」を含む記事は#{paginator.total_count}件見つかりました。"
    end
  end

  def posts
    @decorated_posts ||= super.tap do |original_posts|
      ActiveDecorator::Decorator.instance.decorate(original_posts)
    end
  end

  def to_meta_title
    "#{keywords}の検索結果(#{page_entries_info})"
  end

  def to_meta_description
    MetaTags::TextNormalizer.normalize_description(message)
  end

  def to_og_params
    {
      locale: 'ja_JP',
      type: 'article',
      title: to_meta_title,
      description: to_meta_description,
      url: canonical_url,
      site_name: site.name,
      modified_time: posts.maximum(:updated_at)&.iso8601,
      image: site.logo_image_url
    }
  end

  def excerpt(post)
    snippets = snippet(post.plain_text_body, class: 'search-result__keyword')
    if snippets.empty?
      post.short_text_body
    else
      snippets.map{|snippet| "&hellip;#{snippet}&hellip;" }.join.html_safe
    end
  end

  private

  def page_entries_info
    if paginator.total_pages > 1
      first = paginator.offset_value + 1
      last  = paginator.last_page? ? paginator.total_count : paginator.offset_value + paginator.limit_value

      "#{first}〜#{last}/#{paginator.total_count}件"
    else
      "#{paginator.total_count}件"
    end
  end
end
