class Admin::PostsController < Admin::BaseController
  skip_before_action :check_admin
  before_action :set_posts, only: %i[show edit update destroy]

  def index
    @posts = Post.includes(:user).order(created_at: :desc)
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit; end

  def update
    if @post.update(post_params)
      redirect_to admin_posts_path(@post), success: t('defaults.message.updated', item: Post.model_name.human)
    else
      flash.now[:danger] = t('defaults.message.not_updated', item: Post.model_name.human)
      render :edit
    end
  end

  def destroy
    @post.destroy!
    redirect_to admin_posts_path, success: t('defaults.message.deleted', item: Post.model_name.human)
  end

  private

  def set_posts
    @post = Post.find(params[:id])
  end
  

  def post_params
    params.require(:post).permit(:title, :content, :post_image, :post_image_cache, tag_ids: [])
  end
end