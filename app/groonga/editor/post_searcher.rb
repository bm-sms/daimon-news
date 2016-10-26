class Editor::PostSearcher
  include MarkdownHelper

  class << self
    def search_post_ids(query_params:, page:, site:)
      query = Editor::PostSearchQuery.new(query_params.merge(site_id: site.id))
      new.search_post_ids(query)
    end
  end

  def initialize
    @posts = Groonga["Posts"]
  end

  def search_post_ids(query)
    posts = @posts.select do |record|
      conditions = []
      conditions << (record.site._key == query.site_id)
      if query.title.present?
        match_target = record.match_target do |target|
          target.index("Terms.Posts_title")
        end

        keywords = query.title.split(/[[:blank:]]+/)
        full_text_search = keywords.map {|keyword|
          (match_target =~ keyword)
        }.inject(&:&)
        conditions << full_text_search
      end
      conditions
    end

    posts.collect(&:_key)
  end

  private

  def extract_content(post)
    extract_plain_text(post.body)
  end
end
