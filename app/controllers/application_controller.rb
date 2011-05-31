class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def login_required
    @current_user = session[:user]
    redirect_to login_url and return unless @current_user
    @current_car = @current_user.car || @current_user.build_car
  end
end
