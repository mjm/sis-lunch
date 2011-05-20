class PeopleController < ApplicationController
  respond_to :html
  
  def new
    @person = Person.new
  end
  
  def create
    @person = Person.create(params[:person])
    if @person.valid?
      session[:user] = @person
      respond_with(@person, :location => places_url)
    else
      respond_with(@person) do |format|
        format.html { render :new }
      end
    end
  end
  
  def login
    if request.post?
      session[:user] = Person.authenticate(params[:name], params[:password])
      if session[:user]
        redirect_to places_url
      else
        flash.now[:error] = "Your username or password was incorrect. Please try again."
      end
    end
  end
  
  def logout
    session[:user] = nil
    redirect_to login_url
  end
end
