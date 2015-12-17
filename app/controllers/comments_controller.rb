class CommentsController < ApplicationController
  before_action { routing_error! unless current_site.bbs_enabled? }

  # POST /comments
  def create
    @comment = current_site.topics.find(comment_params[:topic_id]).comments.new(comment_params)

    if @comment.save
      redirect_to @comment.topic, notice: 'Comment was successfully created.'
    else
      redirect_to @comment.topic
    end
  end

  private

    # Only allow a trusted parameter "white list" through.
    def comment_params
      params.require(:comment).permit(:title, :body, :topic_id)
    end
end
