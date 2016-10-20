class PostIndexer
  include MarkdownHelper

  def initialize
    @sites = Groonga["Sites"]
    @categories = Groonga["Categories"]
    @participants = Groonga["Participants"]
    @posts = Groonga["Posts"]
  end

  def add(post)
    return if @posts.nil?
    site = @sites.add(post.site_id)
    categories = []
    post.categories.each do |category|
      categories << @categories.add(category.id, name: category.name)
    end
    participants = []
    post.credits.each do |credit|
      participants << @participants.add(credit.participant_id,
                                        name: credit.participant.name,
                                        summary: credit.participant.summary)
    end
    @posts.add(post.id,
               title: post.title,
               content: extract_content(post),
               published_at: post.published_at,
               site: site,
               categories: categories,
               participants: participants,
               public_id: post.public_id)
  end

  private

  def extract_content(post)
    # Use cache to shorten boot time
    Rails.cache.fetch [:post, :markdown_body, Digest::MD5.hexdigest(post.body)] do
      extract_plain_text(post.body)
    end
  end
end
