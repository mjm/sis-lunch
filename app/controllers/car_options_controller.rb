class CarOptionsController < ApplicationController
  before_filter :login_required

  def update
    had_car = @current_user.has_car?

    @current_user.update_attribute :has_car, params[:has_car]
    if @current_user.has_car?
      @current_car.seats = params[:seats]
      @current_car.save

      if not had_car and @current_user.vote and !@current_user.vote.car
        @current_user.vote.update_attribute :car, @current_car
      end
    end
  end
end