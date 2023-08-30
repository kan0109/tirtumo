class UserSessionsController < ApplicationController
  
  def new; end

  def destroy
    logout
    redirect_to root_path, success: t('.success')
  end

  def login_as
    user = User.find(params[:user_id])
    auto_login(user)
    redirect_to root_path, success: "LINE環境でログインしました"
  end
end
