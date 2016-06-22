class Editor::SerialsController < Editor::ApplicationController
  def index
    @serials = serials.order(id: :desc)
  end

  def show
    @serial = serials.find(params[:id])
  end

  def new
    @serial = serials.build
  end

  def create
    @serial = serials.build(serial_params)

    if @serial.save
      redirect_to [:site, :editor, @serial, {site_id: current_site}], notice: "連載が作成されました"
    else
      render :new
    end
  end

  def edit
    @serial = serials.find(params[:id])
  end

  def update
    @serial = serials.find(params[:id])

    if @serial.update(serial_params)
      redirect_to [:site, :editor, @serial, {site_id: current_site}], notice: "連載が更新されました"
    else
      render :edit
    end
  end

  def destroy
    @serial = serials.find(params[:id])

    @serial.destroy

    redirect_to site_editor_serials_url(site_id: current_site), notice: "連載が削除されました"
  end

  private

  def serials
    current_site.serials
  end

  def serial_params
    params.require(:serial).permit(
      :title,
      :description,
      :thumbnail
    )
  end
end
