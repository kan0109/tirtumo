class RecordsController < ApplicationController
  before_action :require_login
  

  ITEM_PRICES = {
    bottle_bring: 100,
    packed_lunch: 300,
    alternative_transportation: 200,
    no_eating_out: 600
  }.freeze

  def index
    @records = current_user.records
    pp @records
    @savings = calculate_savings(@records)
  end

  def update
    today_records = current_user.records.where("created_at >= ?", Time.zone.now.beginning_of_day)
    if today_records.empty?
      @record = current_user.records.new(record_params)
      if @record.save
        @user_records = current_user.records
        @savings = calculate_savings(@user_records)
        redirect_to records_path, notice: '記録が更新されました。'
      else
        redirect_to records_path, alert: '記録の更新に失敗しました。'
      end
    else
      redirect_to records_path, alert: '1日に一回しか記録を作成できません。'
    end
  end
  

  private

  def record_params
    params.fetch(:record, {}).permit(:bottle_bring, :packed_lunch, :alternative_transportation, :no_eating_out)
  end  

  def calculate_savings(records)
    total_savings = 0 

    records.each do |record|
      @bottle_bring = record.bottle_bring
      @packed_lunch = record.packed_lunch
      @alternative_transportation = record.alternative_transportation
      @no_eating_out = record.no_eating_out

      total_savings += ITEM_PRICES[:bottle_bring] if @bottle_bring
      total_savings += ITEM_PRICES[:packed_lunch] if @packed_lunch
      total_savings += ITEM_PRICES[:alternative_transportation] if @alternative_transportation
      total_savings += ITEM_PRICES[:no_eating_out] if @no_eating_out
    end

    level_up_threshold = 1000  # レベルアップする節約金額のしきい値
    current_user_level = current_user.level || 1  # ユーザーの現在のレベル（初期値は1）

    if total_savings >= level_up_threshold && current_user_level < (total_savings / level_up_threshold).floor
      current_user.update(level: (total_savings / level_up_threshold).floor)
    end

    total_savings
  end
end
