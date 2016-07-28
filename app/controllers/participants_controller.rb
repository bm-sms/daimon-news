class ParticipantsController < ApplicationController
  def index
    @participants = current_site.participants.has_published_posts.sorted.page(params[:page])
    @participants.extend(ParticipantsDecorator)
  end

  def show
    @participant = current_site.participants.with_published_posts.find(params[:id])
    @posts = @participant.posts.published.eager_load(credits: :role).order_by_recent.page(params[:page])

    @posts.extend(PaginationInfoDecorator)
  end
end
