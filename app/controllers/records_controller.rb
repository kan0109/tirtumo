class RecordsController < ApplicationController
  before_action :require_login

  ITEM_PRICES = {
    bottle_bring: 100,
    packed_lunch: 300,
    alternative_transportation: 200,
    no_eating_out: 600
  }.freeze

  def index
    @record = current_user.record || Record.new
    @savings = calculate_savings(@record)
  end

  def update
    @record = current_user.record || Record.new 
    if @record.update(record_params)
      @savings = calculate_savings(@record)
      redirect_to records_path, notice: '記録が更新されました。'
    else
      redirect_to records_path, alert: '記録の更新に失敗しました。'
    end
  end

  private

  def record_params
    params.fetch(:record, {}).permit(:bottle_bring, :packed_lunch, :alternative_transportation, :no_eating_out)
  end  

  def calculate_savings(records)
    total_savings = 0

    ITEM_PRICES.each do |item, price|
      total_savings += price if records[item]
    end

    total_savings
  end
end
