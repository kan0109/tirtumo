class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[line]

  mount_uploader :avatar, AvatarUploader

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes
  has_many :like_posts, through: :likes, source: :post
  has_many :records
  has_many :targets, dependent: :destroy
  has_many :savings_items, dependent: :destroy
  has_one :target

  validates :name, presence: true, length: { maximum: 20 }

  attr_accessor :rank, :rank_value, :monthly_rank, :monthly_rank_value

  def social_profile(provider)
    social_profiles.select { |sp| sp.provider == provider.to_s }.first
  end

  def set_values(omniauth)
    return if provider.to_s != omniauth['provider'].to_s || uid != omniauth['uid']

    credentials = omniauth['credentials']
    info = omniauth['info']

    access_token = credentials['refresh_token']
    access_secret = credentials['secret']
    credentials = credentials.to_json
    name = info['name']
  end

  def set_values_by_raw_info(raw_info)
    self.raw_info = raw_info.to_json
    save!
  end

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
      total_savings:
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
