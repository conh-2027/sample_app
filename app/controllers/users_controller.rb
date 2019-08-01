class UsersController < ApplicationController
  before_action :load_user, only: %i(show edit)

  def index
    @users = User.order(created_at: :desc).page(params[:page])
      .per Settings.user.paging.num_per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "flash.success_create"
      redirect_to @user
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit User::USER_PARAMS
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "flash.not_found"
    redirect_to root_url
  end
end
