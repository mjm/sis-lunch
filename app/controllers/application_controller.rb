class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def login_required
    begin
      @current_user = Person.find(session[:user_id])
      @current_car = @current_user.car || @current_user.build_car
    rescue ActiveRecord::RecordNotFound
      redirect_to login_url
    end
  end
end
