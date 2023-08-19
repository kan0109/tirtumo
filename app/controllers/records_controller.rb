class RecordsController < ApplicationController
  before_action :require_login

  def index
    @records = current_user.records
    @savings = current_user.total_savings
    @result = current_user.result
    @monthly_records = Record.calculate_monthly_records(current_user)
  end  

  def update
    today_records = current_user.records.where('created_at >= ?', Time.zone.now.beginning_of_day)
    if today_records.empty?
      ActiveRecord::Base.transaction do
        @record = current_user.records.new(record_params)
        @savings = current_user.calculate_savings([@record])

        if @record.save
          @user_records = current_user.records
          @result = current_user.result

          flash[:success] = t('defaults.message.updated', item: Record.model_name.human)

          flash[:success] = t('defaults.message.target_money_achievement') if reached_target_amount?
        else
          raise ActiveRecord::Rollback
        end
      end

      redirect_to records_path
    else
      flash[:danger] = t('defaults.message.only_record_once_a_day', item: Record.model_name.human)
      redirect_to records_path
    end
  end  

  private

  def record_params
    params.fetch(:record, {}).permit(:bottle_bring, :packed_lunch, :alternative_transportation, :no_eating_out)
  end

  def reached_target_amount?
    target_amount = current_user.target_amount
    target_amount && @savings >= target_amount
  end
end
