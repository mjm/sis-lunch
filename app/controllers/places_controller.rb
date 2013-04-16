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
    render partial: 'places'
  end

  def create
    @place = @current_user.places.create(params[:place])
    respond_with(@place)
  end

  def edit
    @place = @current_user.places.find(params[:id])
  end

  def update
    @place = @current_user.places.find(params[:id])
    @place.attributes = params[:place]
    @place.save
  end

  def destroy
    @place = @current_user.places.find(params[:id])
    @place.destroy

    respond_with(@place)
  end

  private
    def load_places_data
      @places = @current_user.visible_places.to_a

      @my_place = @current_user.place
      @their_place = @current_user.group.places.most_popular

      @places.delete(@my_place)
      @places.delete(@their_place)
    end

end
