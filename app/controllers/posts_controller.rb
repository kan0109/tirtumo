class PostsController < ApplicationController
  def index
    if params[:latest]
      @posts = Post.latest.includes(:user).order(created_at: :desc).page(params[:page]).per(12)
      flash.now['info '] = t('defaults.message.latest')
    elsif params[:old]
      @posts = Post.old.includes(:user).order(created_at: :desc).page(params[:page]).per(12)
      flash.now['info '] = t('defaults.message.old')
    elsif params[:most_liked]
      @posts = Kaminari.paginate_array(Post.most_liked.to_a.sort_by do |x|
                                         -x.liked_users.size
                                       end.map { |post| post.decorate }).page(params[:page]).per(12)
      flash.now['info '] = t('defaults.message.most_liked')
    else
      @posts = Post.all.includes(:user).order(created_at: :desc).page(params[:page]).per(12)
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
    @like_posts = current_user.like_posts
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :post_image, :post_image_cache)
  end
end
