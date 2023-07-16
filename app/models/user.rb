class User < ApplicationRecord
  authenticates_with_sorcery!
  mount_uploader :avatar, AvatarUploader

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post
  has_many :records
  has_one :target

  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :email, uniqueness: true
  validates :email, presence: true

  validates :name, presence: true, length: { maximum: 20 }

  validates :reset_password_token, uniqueness: true, allow_nil: true

  def own?(object)
    id == object.user_id
  end

  def liked_by?(post_id)
    likes.where(post_id: post_id).exists?
  end

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
