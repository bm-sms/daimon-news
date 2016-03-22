module PostSearchResultSetDecorator
  def canonical_params
    {query: {keywords: keywords}, page: post_ids.current_page}
  end

  def canonical_url
    url_for(canonical_params.merge(only_path: false))
  end

  def message
    if posts.empty?
      "「#{keywords}」を含む記事は見つかりませんでした。"
    elsif post_ids.total_pages > 1
      "「#{keywords}」を含む記事は#{post_ids.total_count}件見つかりました。(#{page_entries_info})"
    else
      "「#{keywords}」を含む記事は#{post_ids.total_count}件見つかりました。"
    end
  end

  def posts
    @decorated_posts ||= super.tap do |original_posts|
      ActiveDecorator::Decorator.instance.decorate(original_posts)
    end
  end

  def post_ids
    @decorated_post_ids ||= super.tap do |original_post_ids|
      ActiveDecorator::Decorator.instance.decorate(original_post_ids)
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
      image: site.logo_url
    }
  end

  private

  def page_entries_info
    if post_ids.total_pages > 1
      first = post_ids.offset_value + 1
      last  = post_ids.last_page? ? post_ids.total_count : post_ids.offset_value + post_ids.limit_value

      "#{first}〜#{last}/#{post_ids.total_count}件"
    else
      "#{post_ids.total_count}件"
    end
  end
end
