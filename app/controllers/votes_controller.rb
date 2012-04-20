class VotesController < ApplicationController
  respond_to :js, :json
  before_filter :login_required

  def create
    Vote.destroy_all(:person_id => @current_user.id)
    @vote = Vote.create(:person => @current_user, :place_id => params[:place], :car_id => params[:car])
    load_places_data

    respond_with(@vote)
  end

  def edit
    @vote = Vote.find(params[:id])
  end

  def update
    @vote = Vote.find(params[:id])
    @vote.attributes = params[:vote]
    @vote.save

    load_places_data

    respond_with(@vote)
  end

  def destroy
    @vote = Vote.find(params[:id])
    @vote.destroy

    load_places_data

    respond_with(@vote)
  end
end
