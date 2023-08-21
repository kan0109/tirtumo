class SavingsItemsController < ApplicationController
  before_action :require_login

  def new
    @savings_item = current_user.savings_items.build
  end

  def create
    existing_items = current_user.savings_items
    if existing_items.empty?
      @savings_item = current_user.savings_items.build(savings_item_params)
      if @savings_item.save
        flash[:success] = t('defaults.message.created_savings_items')
        redirect_to records_path
      else
        render :new
      end
    end
  end

  def edit
    @savings_item = current_user.savings_items.last
  end

  def update
    @savings_item = current_user.savings_items.last
    new_savings_item = current_user.savings_items.build(savings_item_params)

    if new_savings_item.save
      redirect_to records_path, success: t('defaults.message.updated', item: SavingsItem.model_name.human)
    else
      flash.now['danger'] = t('defaults.message.not_updated', item: SavingsItem.model_name.human)
      render :edit
    end
  end

  private

  def savings_item_params
    params.require(:savings_item).permit(:name, :amount)
  end
end
