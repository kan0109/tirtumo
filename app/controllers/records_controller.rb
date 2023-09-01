class RecordsController < ApplicationController
  before_action :authenticate_user!

  def index
    @records = current_user.records
    @savings = current_user.total_savings
    @result = current_user.result
    @monthly_records = Record.calculate_monthly_records(current_user)
    @today_records = current_user.records.where('created_at >= ?', Time.zone.now.beginning_of_day)
    @show_record_form = @today_records.empty?
    @savings_items = current_user.savings_items
  end  

  def update
    today_records = current_user.records.where('created_at >= ?', Time.zone.now.beginning_of_day)
    
    if today_records.empty?
      ActiveRecord::Base.transaction do
        @record = current_user.records.new(record_params)
        
        selected_savings_items = current_user.savings_items.where(id: params.dig(:record, :savings_item_ids))
        @record.savings_item = selected_savings_items.first if selected_savings_items.present?
        @record.savings_item = nil if selected_savings_items.empty?  # Add this line
        
        @savings = current_user.calculate_record_savings(@record)
  
        unless @record.save
          logger.debug @record.errors.full_messages
          raise ActiveRecord::Rollback
        end
        
        @user_records = current_user.records
        @result = current_user.result
  
        flash[:success] = t('defaults.message.updated', item: Record.model_name.human)
  
        flash[:success] = t('defaults.message.target_money_achievement') if reached_target_amount?
      end
  
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
