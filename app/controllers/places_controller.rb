class PlacesController < ApplicationController
  respond_to :html, :js, :json
  before_filter :login_required

  def index
    load_places_data

    @new_place = Place.new
    respond_with @places
  end

  def show
    @place = @current_user.group.places.find(params[:id])
    respond_with @place
  end

  def periodic
    load_places_data

    render :partial => 'places'
  end

  def create
    @place = Place.create(params[:place].merge(:person => @current_user))
    load_places_data

    respond_with(@place)
  end

  def edit
    @place = @current_user.places.find(params[:id])
  end

  def update
    @place = @current_user.places.find(params[:id])
    @place.attributes = params[:place]
    @place.save

    load_places_data
  end

  def destroy
    @place = Place.first(:conditions => {:id => params[:id], :person_id => @current_user})
    @place.destroy
    
    load_places_data
    
    respond_with(@place)
  end

end
