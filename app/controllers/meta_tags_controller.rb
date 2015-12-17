class MetaTagsController < ApplicationController
  before_action :set_meta_tag, only: [:show, :edit, :update, :destroy]

  # GET /meta_tags
  def index
    @meta_tags = MetaTag.all
  end

  # GET /meta_tags/1
  def show
  end

  # GET /meta_tags/new
  def new
    @meta_tag = MetaTag.new
  end

  # GET /meta_tags/1/edit
  def edit
  end

  # POST /meta_tags
  def create
    @meta_tag = MetaTag.new(meta_tag_params)

    if @meta_tag.save
      redirect_to @meta_tag, notice: 'Meta tag was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /meta_tags/1
  def update
    if @meta_tag.update(meta_tag_params)
      redirect_to @meta_tag, notice: 'Meta tag was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /meta_tags/1
  def destroy
    @meta_tag.destroy
    redirect_to meta_tags_url, notice: 'Meta tag was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_meta_tag
      @meta_tag = MetaTag.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def meta_tag_params
      params.require(:meta_tag).permit(:name, :content, :site_id)
    end
end
