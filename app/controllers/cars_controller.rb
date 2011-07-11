class CarsController < ApplicationController
  before_filter :login_required
  
  respond_to :html, :js
  
  def edit
    @car = session[:user].car || Car.new
  end
  
  def create
    save_car
  end
  
  def update
    save_car
  end
  
  private
    def save_car
      @current_user.has_car = params[:has_car]
      @current_user.save
      
      if params[:has_car]
        @current_car.seats = params[:car][:seats]
        unless @current_car.save
          @current_user.update_attribute :has_car, false
        end
      elsif @current_car
        @current_car.destroy
      end
      
      respond_to do |format|
        format.js { render :save }
      end
    end
end
