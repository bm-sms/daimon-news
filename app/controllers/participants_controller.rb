class ParticipantsController < ApplicationController
  before_action :require_accessibility

  class NotAccessible < StandardError
  end

  def index
    @participants = current_site.participants.having_published_posts.sorted.page(params[:page])
    page_not_found_error! if @participants.blank?
    @participants.extend(ParticipantsDecorator)
  end

  def show
    @participant = current_site.participants.having_published_posts.find(params[:id])
    @posts = @participant.posts.published.eager_load(credits: :role).order_by_recent.page(params[:page])
    page_not_found_error! if @posts.blank?
    @posts.extend(PaginationInfoDecorator)
  end

  private

  def require_accessibility
    raise NotAccessible unless current_site.public_participant_page_accessible?
  end
end
