class PopularPostBuilder
  class << self
    def build(site)
      new(site).build
    end
  end

  def initialize(site)
    @site = site
  end

  def build
    @site.transaction do
      remove_old_ranking
      create_new_ranking
    end
  end

  private

  def remove_old_ranking
    @site.popular_posts.destroy_all
  end

  def create_new_ranking
    post_ids.each.with_index(1) do |post_id, rank|
      @site.popular_posts.create!(rank: rank, post_id: post_id)
    end
  end

  def post_ids
    public_ids.map {|public_id| post_id_for(public_id) }
  end

  def post_id_for(public_id)
    valid_post_id_hash[public_id]
  end

  def public_ids
    whole_public_ids
      .lazy.select {|public_id| valid?(public_id) }
      .first(Site::RANKING_SIZE_MAX)
  end

  def valid?(public_id)
    valid_post_id_hash.key?(public_id)
  end

  def whole_public_ids
    @whole_public_ids ||= Ranking::Report.new(@site).ranked_post_public_ids
  end

  def valid_post_id_hash
    @valid_post_id_hash ||= @site.posts.where(public_id: whole_public_ids).where("published_at <= ?", 14.days.ago).pluck(:public_id, :id).to_h
  end
end
