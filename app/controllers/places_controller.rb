class PlacesController < ApplicationController
  respond_to :html, :js, :json
  before_filter :login_required

  def index
    @places = @current_user.group.places.order('votes_count desc').to_a

    @my_place = @current_user.place
    @their_place = Place.most_popular

    @places.delete(@my_place)
    @places.delete(@their_place)

    @new_place = Place.new
    respond_with @places
  end

  def show
    @place = @current_user.group.places.find(params[:id])
    respond_with @place
  end

  def periodic
    @places = @current_user.group.places
    render :partial => 'places'
  end

  def create
    @place = Place.create(params[:place].merge(:person => @current_user))
    @places = @current_user.group.places

    respond_with(@place)
  end

  def edit
    @place = @current_user.places.find(params[:id])
  end

  def update
    @place = @current_user.places.find(params[:id])
    @place.attributes = params[:place]
    @place.save

    @places = @current_user.group.places
  end

  def destroy
    @place = Place.first(:conditions => {:id => params[:id], :person_id => @current_user})
    @place.destroy
    respond_with(@place)
  end


end
