class PostsController < ApplicationController
  def index
    set_posts
    case params[:sort_order]
    when 'latest'
      flash.now[:success] = t('defaults.message.latest')
    when 'old'
      flash.now[:success] = t('defaults.message.old')
    when 'most_liked'
      flash.now[:success] = t('defaults.message.most_liked')
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to posts_path, success: t('defaults.message.created', item: Post.model_name.human)
    else
      flash.now['danger'] = t('defaults.message.not_created', item: Post.model_name.human)
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @comments = @post.comments.includes(:user).order(created_at: :desc)
  end

  def edit
    @post = current_user.posts.find(params[:id])
  end

  def update
    @post = current_user.posts.find(params[:id])
    if @post.update(post_params)
      redirect_to @post, success: t('defaults.message.updated', item: Post.model_name.human)
    else
      flash.now['danger'] = t('defaults.message.not_updated', item: Post.model_name.human)
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to my_page_path, status: :see_other, success: t('defaults.message.deleted', item: Post.model_name.human)
  end

  def likes
    @like_posts = current_user.likes.includes(:post, :user).order(created_at: :desc)
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :post_image, :post_image_cache, tag_ids: [])
  end

  def set_posts
    @posts = if params[:tag_id].present?
               Tag.find(params[:tag_id]).posts
             else
               Post.all.page(params[:page]).per(10)
             end

    @posts = if params[:keyword]
               @posts.search(params[:keyword]).page(params[:page]).per(10)
             else
               @posts.page(params[:page]).per(10)
             end

    @posts = Post.sort_and_paginate(params)
  end
end
