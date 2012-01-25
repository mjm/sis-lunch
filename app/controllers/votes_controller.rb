class VotesController < ApplicationController
  respond_to :js
  before_filter :login_required
  
  def create
    Vote.destroy_all(:person_id => @current_user.id)
    @vote = Vote.create(:person => @current_user, :place_id => params[:place])
    @places = Place.all
  end

  def update
    @vote = Vote.find(params[:id])
    @vote.car_id = params[:car_id]
    @vote.save

    @places = Place.all
  end

  def destroy
    @vote = Vote.find(params[:id])
    @vote.destroy
    @places = Place.all
  end
end
