class PeopleController < ApplicationController
  respond_to :html
  before_filter :login_required, only: [:edit, :update]
  
  def new
    @person = Person.new
  end
  
  def create
    @person = Person.create(params[:person].merge(:signup_ip => request.remote_ip))
    if @person.valid?
      # TODO clean up this stuff
      g = Group.first
      if g
        @person.group = g
        @person.save
      end
      
      session[:user_id] = @person.id
      respond_with(@person, :location => places_url)
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    raise "Cannot update another user's profile" if params[:id].to_i != @current_user.id
    
    @current_user.attributes = params[:person]
    if @current_user.save
      respond_with(@current_user, :location => places_url)
    else
      render :edit
    end
  end
  
  def login
    if request.post?
      @current_user = Person.find_by_name(params[:name]).try(:authenticate, params[:password])
      if @current_user
        session[:user_id] = @current_user.id
        @current_user.login_ip = request.remote_ip
        @current_user.save
        redirect_to places_url
      else
        flash.now[:error] = t('people.login.failed')
      end
    end
  end
  
  def logout
    session[:user_id] = nil
    redirect_to login_url
  end
end
