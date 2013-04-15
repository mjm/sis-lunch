class VotesController < ApplicationController
  respond_to :js, :json
  before_filter :login_required

  def create
    Vote.destroy_all(person_id: @current_user.id)
    @vote = Vote.new person: @current_user
    @vote.place_id = params[:place]
    @vote.car_id = params[:car]
    @vote.save

    respond_with(@vote)
  end

  def edit
    @vote = Vote.first(conditions: {id: params[:id], person_id: @current_user.id})
    raise ActiveRecord::RecordNotFound, 'could not find vote' if @vote.nil?
  end

  def update
    @vote = Vote.first(conditions: {id: params[:id], person_id: @current_user.id})
    raise ActiveRecord::RecordNotFound, 'could not find vote' if @vote.nil?
    @vote.comment = params[:vote][:comment]
    @vote.save

    respond_with(@vote)
  end

  def destroy
    @vote = Vote.first(conditions: {id: params[:id], person_id: @current_user.id})
    raise ActiveRecord::RecordNotFound, 'could not find vote' if @vote.nil?
    @vote.destroy

    respond_with(@vote)
  end
end
