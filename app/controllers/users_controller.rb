class UsersController < ApplicationController
  before_action :logged_in_user, :correct_user, only: %i(edit update)
  before_action :admin_user, only: %i(destroy)
  before_action :load_user, only: %i(show edit update)

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
      @user.send_activation_email
      flash[:info] = t "flash.active"
      redirect_to root_url
    else
      render :new
    end
  end

  def update
    if @user.update user_params
      flash[:success] = t "flash.success_update"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "flash.success_delete"
    else
      flash[:fail] = t "flash.fail_delete"
    end
    redirect_to users_path
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

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "flash.please"
    redirect_to login_url
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to root_url unless @user == current_user || current_user.admin?
  end
end
