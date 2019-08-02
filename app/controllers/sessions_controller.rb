class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == Settings.remember_me ? remember(user) : forget(user)
      redirect_to current_user
    else
      flash[:danger] = t "flash.login_fail"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
