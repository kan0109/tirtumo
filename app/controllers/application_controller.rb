class ApplicationController < ActionController::Base
  add_flash_types :success, :info, :warning, :danger
  before_action :require_login, except: %i[new_password_reset login]

  private

  def not_authenticated
    flash[:warning] = t('defaults.message.require_login')
    redirect_to login_path
  end

  def require_login
    return if current_user

    redirect_to login_path
  end
end
