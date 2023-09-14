class Admin::BaseController < ApplicationController
  before_action :check_admin
  before_action :authenticate_user!
  layout 'admin'

  private

  def check_admin
    return if current_user&.admin?

    flash.now[:danger] = t('defaults.message.not_authorized')
    redirect_to root_path
  end
end