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

  protected
    def load_places_data
      @places = @current_user.group.places.order('votes_count desc').to_a

      @my_place = @current_user.place
      @their_place = Place.most_popular

      @places.delete(@my_place)
      @places.delete(@their_place)
    end
end
