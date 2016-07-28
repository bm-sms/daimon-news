class ParticipantsController < ApplicationController
  before_action :require_view_participants

  class NotAllowed < StandardError
  end

  def index
    @participants = current_site.participants.having_published_posts.sorted.page(params[:page])
    @participants.extend(ParticipantsDecorator)
  end

  def show
    @participant = current_site.participants.having_published_posts.find(params[:id])
    @posts = @participant.posts.published.eager_load(credits: :role).order_by_recent.page(params[:page])

    @posts.extend(PaginationInfoDecorator)
  end

  private

  def require_view_participants
    raise NotAllowed unless current_site.view_participants?
  end
end
