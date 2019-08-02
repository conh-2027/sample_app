class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user  = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "flash.sent_password_reset"
      redirect_to root_path
    else
      flash[:info] = t "flash.email_not_found"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, t(".password_emtpy")
      render :edit
    elsif @user.update user_params
      log_in @user
      flash[:success] = t ".reset_success"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def load_user
    @user = User.find_by email: params[:email]
    return if @user
    flash[:danger] = t "flash.not_found"
    render :new
  end

  def valid_user
    return if @user && @user.activated? && @user.authenticated?(:reset, params[:id])
    flash[:danger] = t "flash.email_valid"
    redirect_to new_password_reset_path
  end

  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t "flash.expired_reset"
    redirect_to new_password_reset_url
  end
end
