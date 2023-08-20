class SavingsItemsController < ApplicationController
  before_action :require_login

  def new
    @savings_item = current_user.savings_items.new
  end

  def create
    if current_user.savings_items.count < 2
      @savings_item = current_user.savings_items.new(savings_item_params)
      if @savings_item.save
        flash[:success] = '節約アイテムが正常に作成されました。'
        redirect_to records_path
      else
        render :new
      end
    else
      flash[:error] = '節約アイテムは最大2つまでしか作成できません。'
      redirect_to records_path
    end
  end

  private

  def savings_item_params
    params.require(:savings_item).permit(:name, :amount)
  end
end
