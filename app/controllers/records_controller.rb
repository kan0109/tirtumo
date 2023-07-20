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
    @savings = calculate_savings(@records)
  end

  def update
    today_records = current_user.records.where("created_at >= ?", Time.zone.now.beginning_of_day)
    if today_records.empty?
      @record = current_user.records.new(record_params)
      if @record.save
        @user_records = current_user.records
        @savings = calculate_savings(@user_records)
        current_user.update(total_savings: @savings)
        flash[:success] = t('defaults.message.updated', item: Record.model_name.human)
        redirect_to records_path
      else
        flash[:danger] = t('defaults.message.not_updated', item: Record.model_name.human)
        redirect_to records_path
      end
    else
      flash[:danger] = t('defaults.message.only_record_once_a_day', item: Record.model_name.human)
      redirect_to records_path
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

  private

  def determine_level(level)
    case level
    when 1..5
      "初級"
    when 6..15
      "中級"
    when 16..25
      "上級"
    else
      "マスター"
    end
  end

  def level_up?(current_level, total_savings)
    level_up_thresholds = {
      "初級" => 5,
      "中級" => 15,
      "上級" => 25,
      "マスター" => Float::INFINITY
    }

    next_level = determine_level(current_level + 1)
    total_savings >= level_up_thresholds[next_level]
  end
end
