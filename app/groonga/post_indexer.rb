class PostIndexer
  def initialize
    @sites = Groonga['Sites']
    @categories = Groonga['Categories']
    @participants = Groonga['Participants']
    @posts = Groonga['Posts']
  end

  def add(post)
    return if @posts.nil?
    site = @sites.add(post.site_id)
    if post.category
      category = @categories.add(post.category_id)
    else
      category = nil
    end
    participants = post.credits.map do |credit|
      @participants.add(credit.participant_id)
    end
    @posts.add(post.id,
               title: post.title,
               content: extract_content(post),
               published_at: post.published_at,
               site: site,
               category: category,
               participants: participants,
               public_id: post.public_id)
  end

  def remove(post)
    return if @posts.nil?
    @posts[post.id].delete
  end

  private

  def extract_content(post)
    post.body
  end
end
