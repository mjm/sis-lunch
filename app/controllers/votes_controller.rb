class VotesController < ApplicationController
  respond_to :js
  before_filter :login_required
  
  def create
    @vote = Vote.create(:person => session[:user], :place_id => params[:place])
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
