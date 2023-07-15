class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def index
    @users = User.all
    # もしくは、適切なクエリを使用してユーザーを取得する
    # 例: @users = User.where(role: 'user')
    @savings = 1000  # 仮の節約金額

    # @userに値を代入する
    @user = current_user
  end
  
  def new 
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to login_path, success: t('.success')
    else
      flash.now[:danger] = t('.fail')
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name)
  end
end
