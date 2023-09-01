class Record < ApplicationRecord
  belongs_to :user
  belongs_to :savings_item, optional: true # nil のままでも保存が可能
  include SharedConstants

  scope :for_month, ->(month) { where(created_at: month.beginning_of_month..month.end_of_month) }

  def self.calculate_monthly_records(user)
    user.records.group_by { |record| record.created_at.beginning_of_month }.map do |month, records_in_month|
      monthly_total_savings = calculate_savings(records_in_month)
      {
        month: month.strftime('%Y-%m'),
        total_savings: monthly_total_savings,
        monthly_records: records_in_month
      }
    end
  end

  def self.calculate_savings(records)
    total_savings = 0

    records.each do |record|
      total_savings += record.savings_item.amount if record.savings_item.present?
      total_savings += ITEM_PRICES[:bottle_bring] if record.bottle_bring
      total_savings += ITEM_PRICES[:packed_lunch] if record.packed_lunch
      total_savings += ITEM_PRICES[:alternative_transportation] if record.alternative_transportation
      total_savings += ITEM_PRICES[:no_eating_out] if record.no_eating_out
    end

    total_savings
  end
end
