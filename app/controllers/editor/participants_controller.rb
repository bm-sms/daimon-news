class Editor::ParticipantsController < Editor::ApplicationController
  def index
    @participants = participants.order(:name)
  end

  def show
    @participant = participants.find(params[:id])
  end

  def new
    @participant = participants.build
  end

  def create
    @participant = participants.build(participant_params)

    if @participant.save
      redirect_to [:editor, @participant], notice: '関係者情報が作成されました'
    else
      render :new
    end
  end

  def edit
    @participant = participants.find(params[:id])
  end

  def update
    @participant = participants.find(params[:id])

    if @participant.update(participant_params)
      redirect_to [:editor, @participant], notice: '関係者情報が更新されました'
    else
      render :edit
    end
  end

  def destroy
    @participant = participants.find(params[:id])

    @participant.destroy

    redirect_to editor_participants_url, notice: '関係者情報が削除されました'
  end

  private

  def participants
    current_site.participants
  end

  def participant_params
    params.require(:participant).permit(
      :name,
      :description,
      :photo,
      :remove_photo
    )
  end
end
