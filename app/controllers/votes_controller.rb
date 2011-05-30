class VotesController < ApplicationController
  respond_to :js
  before_filter :login_required
  
  def create
    @vote = Vote.create(:person => session[:user], :place_id => params[:place])
    @places = Place.all
    respond_with(@vote)
  end
  
  def destroy
    @vote = Vote.find(params[:id])
    @vote.destroy
    @places = Place.all
    respond_with(@vote)
  end
end
