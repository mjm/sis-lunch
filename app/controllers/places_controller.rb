class PlacesController < ApplicationController
  respond_to :html, :js
  before_filter :login_required
  
  def index
    @places = Place.all
    @place = Place.new
    respond_with(@places)
  end
  
  def create
    @place = Place.create(params[:place].merge(:person => session[:user]))
    if @place.valid?
      @places = Place.all
      respond_with(@place)
    else
      
    end
  end
  
  def destroy
    @place = Place.find(params[:id])
    @place.destroy
    respond_with(@place)
  end
  
  
end
