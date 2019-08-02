class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      redirect_to user
      flash[:success] = t "flash.success"
    else
      flash[:danger] = t "flash.active"
      redirect_to root_url
    end
  end
end
