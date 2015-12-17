class TopicsController < ApplicationController
  before_action :setup_site
  before_action :set_topic, only: [:show, :edit, :update, :destroy]

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

  # GET /topics/1/edit
  def edit
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

  # PATCH/PUT /topics/1
  def update
    if @topic.update(topic_params)
      redirect_to @topic, notice: 'Topic was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /topics/1
  def destroy
    @topic.destroy
    redirect_to topics_url, notice: 'Topic was successfully destroyed.'
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
