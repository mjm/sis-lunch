# This would make more sense right now as a single resource, since a
# person only has a single vote at the moment. Groups may change that
# dynamic.

class VotesController < ApplicationController
  respond_to :js, :json
  before_filter :login_required

  def create
    @vote = Vote.register(@current_user, params[:place], params[:car])
    respond_with(@vote)
  end

  def edit
    @vote = @current_user.vote
    raise ActiveRecord::RecordNotFound, 'could not find vote' unless @vote.id == params[:id].to_i
  end

  def update
    @vote = Vote.update_comment(params[:id], @current_user, params[:vote][:comment])
    respond_with(@vote)
  end

  def destroy
    @vote = @current_user.vote
    raise ActiveRecord::RecordNotFound, 'could not find vote' unless @vote.id == params[:id].to_i
    @vote.destroy

    respond_with(@vote)
  end
end
