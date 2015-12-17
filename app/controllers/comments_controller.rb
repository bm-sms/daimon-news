class CommentsController < ApplicationController
  before_action :setup_site

  # POST /comments
  def create
    @comment = @site.topics.find(comment_params[:topic_id]).comments.new(comment_params)

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
