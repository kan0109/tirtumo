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
    @savings = calculate_savings(@user.record)
  end

  private

  def calculate_savings(records)
    total_savings = 0

    ITEM_PRICES.each do |item, price|
      total_savings += price if records[item]
    end

    total_savings
  end
end
