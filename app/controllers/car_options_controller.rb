class CarOptionsController < ApplicationController
  before_filter :login_required

  def update
    @result = @current_user.update_car_options(params)
  end
end