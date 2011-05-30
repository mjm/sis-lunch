class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def login_required
    @current_user = session[:user]
    @current_car = @current_user.car || @current_user.build_car
    redirect_to login_url unless session[:user]
  end
end
