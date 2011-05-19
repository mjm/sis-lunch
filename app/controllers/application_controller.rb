class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def login_required
    redirect_to login_url unless session[:user]
  end
end
