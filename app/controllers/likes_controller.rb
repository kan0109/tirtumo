class LikesController < ApplicationController
  before_action :post_params

  def create
    like = Like.find_or_initialize_by(user_id: current_user.id, post_id: params[:id])
    like.save
    @post.create_notification_like!(current_user)
    redirect_to posts_path, success: t('defaults.message.liked', item: Like.model_name.human)
  end
  

  def destroy
    like = Like.find_by(user_id: current_user.id, post_id: params[:id])
    if like
      like.destroy
    end
    redirect_to posts_path, danger: t('defaults.message.not_liked', item: Like.model_name.human)
  end

  private

  def post_params
    @post = Post.find(params[:id])
  end
end