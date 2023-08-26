class User < ApplicationRecord
  authenticates_with_sorcery!
  mount_uploader :avatar, AvatarUploader

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes
  has_many :like_posts, through: :likes, source: :post
  has_many :records
  has_many :targets, dependent: :destroy
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy
  has_many :savings_items, dependent: :destroy

  has_one :target

  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :reset_password_token, presence: true, uniqueness: true, allow_nil: true

  validates :email, uniqueness: true, presence: true

  validates :name, presence: true, length: { maximum: 20 }

  validates :reset_password_token, uniqueness: true, allow_nil: true

  attr_accessor :rank, :rank_value, :monthly_rank, :monthly_rank_value

  def own?(object)
    id == object.user_id
  end

  def like(post)
    like_posts << post
  end

  def unlike(post)
    like_posts.destroy(post)
  end

  def like?(post)
    like_posts.include?(post)
  end

  def result
    total_savings = calculate_savings(records)

    {
      total_savings: total_savings,
    }
  end

  def total_savings
    calculate_savings(records)
  end

  def calculate_monthly_records_for_user(records_in_month)
    calculate_savings(records_in_month)
  end

  def calculate_savings(records)
    total_savings = 0

    records.each do |record|
      total_savings += calculate_record_savings(record)
    end
  
    total_savings
  end
  
  def calculate_record_savings(record)
    total_savings = 0
  
    total_savings += record.savings_item.amount if record.savings_item.present?
    total_savings += item_prices[:bottle_bring] if record.bottle_bring
    total_savings += item_prices[:packed_lunch] if record.packed_lunch
    total_savings += item_prices[:alternative_transportation] if record.alternative_transportation
    total_savings += item_prices[:no_eating_out] if record.no_eating_out
  
    total_savings
  end
  

  def item_prices
    SharedConstants::ITEM_PRICES
  end

  def target_amount
    target = self.target
    target&.target_amount
  end
end
