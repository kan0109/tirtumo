class RecordsController < ApplicationController
  before_action :require_login

  ITEM_PRICES = {
    bottle_bring: 100,
    packed_lunch: 300,
    alternative_transportation: 200,
    no_eating_out: 300
  }.freeze

  def index
    @records = current_user.records
    @savings = calculate_savings(@records)
    @monthly_records = get_all_monthly_records(current_user)
  end

  def update
    today_records = current_user.records.where('created_at >= ?', Time.zone.now.beginning_of_day)
    if today_records.empty?
      @record = current_user.records.new(record_params)
      if @record.save
        @user_records = current_user.records
        @savings = calculate_savings(@user_records)
        current_user.update(total_savings: @savings)
        flash[:success] = t('defaults.message.updated', item: Record.model_name.human)

        flash[:success] = t('defaults.message.target_money_achievement') if reached_target_amount?

        if logged_in? && current_user && current_user.level && current_user.level >= 6 && current_user.level % 10 == 6
          flash.now[:firework] = true
        end

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

  def get_all_monthly_records(user)
    user.records.group_by { |record| record.created_at.beginning_of_month }.map do |month, records_in_month|
      {
        month: month.strftime('%Y-%m'),
        total_savings: calculate_savings(records_in_month),
      }
    end
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

    level_up_threshold = 1000
    current_user_level = current_user.level || 1

    if total_savings >= level_up_threshold && current_user_level < (total_savings / level_up_threshold).floor
      current_user.update(level: (total_savings / level_up_threshold).floor)
    end

    if logged_in? && current_user.level && current_user.level >= 6 && current_user.level % 10 == 6
      flash.now[:success] = "おめでとうございます！！あなたは#{determine_level(current_user.level)}になりました！"
    end

    total_savings
  end

  def determine_level(level)
    case level
    when 1..5
      '見習い'
    when 6..15
      '一人前'
    when 16..25
      '名人'
    else
      '達人'
    end
  end

  def level_up?(current_level, total_savings)
    level_up_thresholds = {
      '見習い' => 5,
      '一人前' => 15,
      '名人' => 25,
      '達人' => Float::INFINITY
    }

    next_level = determine_level(current_level + 1)
    total_savings >= level_up_thresholds[next_level]
  end

  def reached_target_amount?
    target_amount = current_user.target_amount
    target_amount && @savings >= target_amount
  end
end
