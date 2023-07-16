module RecordsHelper
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
end
