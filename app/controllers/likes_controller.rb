class LikesController < ApplicationController
  before_action :post_params

  def create
    like = Like.find_or_initialize_by(user_id: current_user.id, post_id: params[:id])
    if like.persisted?
      # すでにいいねが存在する場合の処理
      flash[:notice] = "You have already liked this post."
    else
      # 新しいいいねを作成する場合の処理
      like.save
    end
    redirect_to posts_path, success: t('defaults.message.liked', item: Like.model_name.human)
  end
  

  def destroy
    like = Like.find_by(user_id: current_user.id, post_id: params[:id])
    if like
      like.destroy
    end
    redirect_to posts_path
  end

  private

  def post_params
    @post = Post.find(params[:id])
  end
end