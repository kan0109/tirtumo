class TargetsController < ApplicationController
  before_action :require_login

  def new
    @target = Target.new
  end

  def create
    @target = current_user.targets.build(target_params)
    if @target.save
      current_user.update(target_amount: @target.target_amount)
      flash[:success] = t('defaults.message.created', item: Target.model_name.human)
      redirect_to my_page_path
    else
      flash[:danger] = t('defaults.message.not_created', item: Target.model_name.human)
      render :new
    end
  end

  private

  def target_params
    params.require(:target).permit(:target, :target_amount)
  end
end
