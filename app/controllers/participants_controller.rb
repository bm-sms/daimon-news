class ParticipantsController < ApplicationController
  def show
    @participant = current_site.participants.find(params[:id])
    @posts = @participant.posts.published.order_by_recent.page(params[:page])

    @posts.extend(PaginationInfoDecorator)
  end
end
