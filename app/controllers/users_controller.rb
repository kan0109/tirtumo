class UsersController < ApplicationController


  def index
    @users = User.includes(:records).all.sort_by { |user| user.result[:total_savings] }.reverse
    assign_ranks
    @users = Kaminari.paginate_array(@users).page(params[:page]).per(10)
  end

  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to login_path, success: t('.success')
    else
      flash.now[:danger] = t('.fail')
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    @latest_target = @user.targets.last
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end

  def assign_ranks
    current_rank = 1
    current_savings = nil

    @users.each_with_index do |user, index|
      total_savings = user.result[:total_savings]

      if current_savings != total_savings
        current_rank = index + 1
        current_savings = total_savings
      end

      user.rank = current_rank
    end
  end
end
