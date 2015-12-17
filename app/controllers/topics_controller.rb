class TopicsController < ApplicationController
  before_action :setup_site
  before_action { routing_error! unless @site.bbs_enabled? }
  before_action :set_topic, only: :show

  # GET /topics
  def index
    @topics = @site.topics
  end

  # GET /topics/1
  def show
    @comment = Comment.new(topic: @topic)
  end

  # GET /topics/new
  def new
    @topic = @site.topics.new
  end

  # POST /topics
  def create
    @topic = @site.topics.new(topic_params)

    if @topic.save
      redirect_to @topic, notice: 'Topic was successfully created.'
    else
      render :new
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_topic
      @topic = @site.topics.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def topic_params
      params.require(:topic).permit(:title, :body)
    end
end
