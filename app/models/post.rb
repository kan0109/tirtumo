class Post < ApplicationRecord
  mount_uploader :post_image, PostImageUploader
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :notifications, dependent: :destroy

  validates :title, presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: { maximum: 65_535 }

  scope :latest, -> { order(created_at: :desc) }  # desc = 降順
  scope :old, -> { order(created_at: :asc) } # asc = 昇順
  scope :most_liked, lambda {
                       includes(:liked_users)
                         .sort_by { |x| x.liked_users.includes(:likes).size }.reverse
                     }

  def create_notification_like!(current_user)
    # すでに「いいね」されているか検索
    temp = Notification.where(['visitor_id = ? and visited_id = ? and post_id = ? and action = ? ', current_user.id,
                               user_id, id, 'like'])
    # いいねされていない場合のみ、通知レコードを作成
    return unless temp.blank?

    notification = current_user.active_notifications.new(
      post_id: id,
      visited_id: user_id,
      action: 'like'
    )
    # 自分の投稿に対するいいねの場合は、通知済みとする
    notification.checked = true if notification.visitor_id == notification.visited_id
    notification.save if notification.valid?
  end

  def create_notification_comment!(current_user, comment_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    temp_ids = Comment.select(:user_id).where(post_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment!(current_user, comment_id, temp_id['user_id'])
    end
    # まだ誰もコメントしていない場合は、投稿者に通知を送る
    save_notification_comment!(current_user, comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_comment!(current_user, comment_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      post_id: id,
      comment_id:,
      visited_id:,
      action: 'comment'
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    notification.checked = true if notification.visitor_id == notification.visited_id
    notification.save if notification.valid?
  end
end
