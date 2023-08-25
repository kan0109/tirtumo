class TargetsController < ApplicationController
  before_action :require_login

  def new
    @target = Target.new
  end

  def create
    ActiveRecord::Base.transaction do
      @target = current_user.targets.build(target_params)
      if @target.save
        flash[:success] = t('defaults.message.created', item: Target.model_name.human)
        redirect_to my_page_path
      else
        flash[:danger] = t('defaults.message.not_created', item: Target.model_name.human)
        render :new
        raise ActiveRecord::Rollback
      end
    end
  end

  def edit
    @target = current_user.targets.find(params[:id])
  end

  def update
    @target = current_user.targets.find(params[:id])
    if @target.update(target_params)
      redirect_to @target, success: t('defaults.message.updated', item: Target.model_name.human)
    else
      flash.now['danger'] = t('defaults.message.not_updated', item: Target.model_name.human)
      render :edit
    end
  end

  private

  def target_params
    params.require(:target).permit(:target, :target_amount)
  end
end
