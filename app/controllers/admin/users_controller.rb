class Admin::UsersController < Admin::ApplicationController
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_users_url, notice: 'ユーザが作成されました。'
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to admin_users_url, notice: 'ユーザが更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])

    @user.destroy!

    redirect_to admin_users_url, notice: 'ユーザが削除されました。'
  end

  private

  def user_params
    params.require(:user).permit(
      :email,
      :password,
      :password_confirmation,
      :admin
    )
  end
end
