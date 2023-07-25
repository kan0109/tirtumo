class MyPagesController < ApplicationController
  before_action :require_login

  ITEM_PRICES = {
    bottle_bring: 100,
    packed_lunch: 300,
    alternative_transportation: 200,
    no_eating_out: 600
  }.freeze

  def show
    @user = current_user
    @records = current_user.records
    @savings = calculate_savings(@records)
  end

  private

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

    total_savings
  end
end
