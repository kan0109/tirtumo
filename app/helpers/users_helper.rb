module UsersHelper
  def calculate_savings(records)
    total_savings = 0

    records.each do |record|
      total_savings += RecordsController::ITEM_PRICES[:bottle_bring] if record.bottle_bring
      total_savings += RecordsController::ITEM_PRICES[:packed_lunch] if record.packed_lunch
      total_savings += RecordsController::ITEM_PRICES[:alternative_transportation] if record.alternative_transportation
      total_savings += RecordsController::ITEM_PRICES[:no_eating_out] if record.no_eating_out
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
end
