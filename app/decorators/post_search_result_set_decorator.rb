module PostSearchResultSetDecorator
  def canonical_params
    {query: {keywords: keywords}, page: posts.current_page}
  end

  def canonical_url
    url_for(canonical_params.merge(only_path: false))
  end

  def message
    if keywords.empty?
      "検索キーワードを入力してください。"
    elsif posts.empty?
      "「#{keywords}」を含む記事は見つかりませんでした。"
    elsif posts.total_pages > 1
      "「#{keywords}」を含む記事は#{posts.total_count}件見つかりました。(#{posts.page_entries_info})"
    else
      "「#{keywords}」を含む記事は#{posts.total_count}件見つかりました。"
    end
  end

  def posts
    @decorated_posts ||= super.tap {|original_posts|
      ActiveDecorator::Decorator.instance.decorate(original_posts)
    }.extend(PaginationInfoDecorator)
  end

  def to_meta_title
    "#{keywords}の検索結果(#{posts.page_entries_info})"
  end

  def to_meta_description
    MetaTags::TextNormalizer.normalize_description(message)
  end

  def to_og_params
    {
      locale: "ja_JP",
      type: "article",
      title: to_meta_title,
      description: to_meta_description,
      url: canonical_url,
      site_name: site.name,
      modified_time: posts.maximum(:updated_at)&.iso8601,
      image: site.logo_image_url
    }
  end

  def excerpt(post)
    snippets = []
    post.credits.each do |credit|
      snippets.concat(snippet(credit.participant.name, class: "search-result__keyword"))
      snippets.concat(snippet(credit.participant.description, class: "search-result__keyword"))
    end
    snippets.concat(snippet(post.plain_text_body, class: "search-result__keyword"))
    if snippets.empty?
      post.short_text_body
    else
      snippets.map{|snippet| "&hellip;#{snippet}&hellip;" }.join.html_safe
    end
  end
end
