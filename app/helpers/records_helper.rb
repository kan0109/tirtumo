module RecordsHelper
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
