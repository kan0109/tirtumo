class ApplicationController < ActionController::Base
  add_flash_types :success, :info, :warning, :danger

  def after_sign_in_path_for(resource)
    if resource.is_a?(User) && resource.admin?
      admin_root_path
    else
      root_path
    end
  end

  private

  def not_authenticated
    flash[:warning] = t('defaults.message.require_login')
    redirect_to login_path
  end
end
