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
  
  before_filter :prepend_view_path_if_mobile
 
  private 
    def prepend_view_path_if_mobile
      prepend_view_path Rails.root + 'app' + 'views' + 'mobile' if mobile_request?
    end
 
    def mobile_request?
      request.subdomains.first == 'm'
    end
    helper_method :mobile_request?
end
