class PlacesController < ApplicationController
  respond_to :html, :js
  before_filter :login_required
  
  def index
    @places = Place.all
    @place = Place.new
    respond_with(@places)
  end
  
  def periodic
    @places = Place.all
    render :partial => 'places'
  end
  
  def create
    @place = Place.create(params[:place].merge(:person => session[:user]))
    @places = Place.all
    respond_with(@place, :location => places_url)
  end
  
  def destroy
    @place = Place.first(:conditions => {:id => params[:id], :person_id => session[:user]})
    @place.destroy
    respond_with(@place)
  end
  
  
end
