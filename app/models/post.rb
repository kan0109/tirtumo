class Post < ApplicationRecord
  mount_uploader :post_image, PostImageUploader
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :association_post_and_tags, dependent: :destroy
  has_many :tags, through: :association_post_and_tags


  validates :title, presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: { maximum: 65_535 }

  scope :latest, -> { order(created_at: :desc) } 
  scope :old, -> { order(created_at: :asc) }
  scope :most_liked, lambda {
                      includes(:liked_users)
                        .sort_by { |x| x.liked_users.includes(:likes).size }.reverse
                    }

  def self.search(keyword)
    where("title LIKE ? or content LIKE ?", "%#{sanitize_sql_like(keyword)}%", "%#{sanitize_sql_like(keyword)}%")
  end  

  def self.sort_and_paginate(params)
    posts = self.all
    if params[:tag_id].present?
      posts = Tag.find(params[:tag_id]).posts
    end

    if params[:keyword].present?
      posts = posts.search(params[:keyword])
    end

    case params[:sort_order]
    when "latest"
      posts = posts.sort_by { |post| post.created_at }.reverse
    when "old"
      posts = posts.sort_by { |post| post.created_at }
    when "most_liked"
      posts = posts.sort_by { |post| -post.liked_users.size }
    else
      posts = posts.sort_by { |post| post.created_at }.reverse
    end

    Kaminari.paginate_array(posts).page(params[:page]).per(10)
  end
end
