require 'spec_helper'

describe PlacesController do
  context "with a logged-in user" do
    before :each do
      @user = create(:person, :with_group)
    end

    def as_user(method, action, params = nil, session = nil, flash = nil)
      session ||= {}
      session = session.merge({user_id: @user.id})

      send(method, action, params, session, flash)
    end

    describe "GET #index" do
      it "should render the index view" do
        as_user :get, :index
        response.should render_template('index')
      end

      it "should build an empty new place" do
        as_user :get, :index
        assigns(:new_place).should_not be_nil
      end

      context "when some places exist" do
        before :each do
          person = create(:person, group: @user.group)
          create_list(:place, 10, person: person)
        end

        it "should load the current user's choice" do
          as_user :get, :index
          assigns(:my_place).should be_nil

          @user.place = create(:place, person: @user)
          as_user :get, :index
          assigns(:my_place).should == @user.place
        end

        it "should load the most popular choice" do
          as_user :get, :index
          assigns(:their_place).should be_nil

          create(:place, person: @user, votes_count: 5)
          as_user :get, :index
          assigns(:their_place).should == Place.most_popular
        end

        it "should not include current user choice in other places" do
          @user.place = create(:place, person: @user)
          as_user :get, :index
          assigns(:places).should_not include(@user.place)
        end

        it "should not include most popular choice in other places" do
          create(:place, person: @user, votes_count: 5)
          as_user :get, :index
          assigns(:places).should_not include(Place.most_popular)
        end
      end

      context "when no places exist" do
        it "should have no user choice" do
          as_user :get, :index
          assigns(:my_place).should be_nil
        end

        it "should have no most popular choice" do
          as_user :get, :index
          assigns(:their_place).should be_nil
        end

        it "should load no places" do
          as_user :get, :index
          assigns(:places).should be_empty
        end
      end
    end

    describe "GET #show" do
      before :each do
        @place = create(:place, person: create(:person, group: @user.group))
      end

      it "should render the show view" do
        as_user :get, :show, id: @place.id, format: 'json'
        response.should render_template('show')
      end

      it "should 404 if the place ID does not exist" do
        -> { as_user :get, :show, id: @place.id + 1, format: 'json' }.should raise_error(ActiveRecord::RecordNotFound)
      end

      it "should 404 if the place is not in the current user's group" do
        place = create(:place, person: create(:person, :with_group))
        -> { as_user :get, :show, id: place.id, format: 'json' }.should raise_error(ActiveRecord::RecordNotFound)
      end
    end

    describe "GET #periodic" do
      it "should render the places partial view" do
        as_user :get, :periodic
        response.should render_template('_places')
      end

      context "when some places exist" do
        before :each do
          person = create(:person, group: @user.group)
          create_list(:place, 10, person: person)
        end

        it "should load the current user's choice" do
          as_user :get, :periodic
          assigns(:my_place).should be_nil

          @user.place = create(:place, person: @user)
          as_user :get, :periodic
          assigns(:my_place).should == @user.place
        end

        it "should load the most popular choice" do
          as_user :get, :periodic
          assigns(:their_place).should be_nil

          create(:place, person: @user, votes_count: 5)
          as_user :get, :periodic
          assigns(:their_place).should == Place.most_popular
        end

        it "should not include current user choice in other places" do
          @user.place = create(:place, person: @user)
          as_user :get, :periodic
          assigns(:places).should_not include(@user.place)
        end

        it "should not include most popular choice in other places" do
          create(:place, person: @user, votes_count: 5)
          as_user :get, :periodic
          assigns(:places).should_not include(Place.most_popular)
        end
      end

      context "when no places exist" do
        it "should have no user choice" do
          as_user :get, :periodic
          assigns(:my_place).should be_nil
        end

        it "should have no most popular choice" do
          as_user :get, :periodic
          assigns(:their_place).should be_nil
        end

        it "should load no places" do
          as_user :get, :periodic
          assigns(:places).should be_empty
        end
      end
    end

    describe "POST #create" do
      context "when the place is valid" do
        before :each do
          @place = attributes_for(:place)
          as_user :post, :create, place: @place, format: 'js'
        end

        it "should render the create JS view" do
          response.should render_template('create')
        end

        it "should create the place" do
          Place.find_by_name(@place[:name]).should_not be_nil
        end

        it "should assign the place to the current user" do
          Place.find_by_name(@place[:name]).person.should == @user
        end
      end

      context "when the place is invalid" do
        before :each do
          @place = attributes_for(:place, name: nil)
          as_user :post, :create, place: @place, format: 'js'
        end

        it "should render the create JS view" do
          response.should render_template('create')
        end

        it "should not create the place" do
          Place.find_by_name(@place[:name]).should be_nil
        end
      end
    end

    describe "GET #edit" do
      before :each do
        @place = create(:place, person: @user)
      end

      it "should render the edit view" do
        as_user :get, :edit, id: @place.id, format: 'js'
        response.should render_template('edit')
      end

      it "should 404 if the place ID does not exist" do
        -> { as_user :get, :edit, id: @place.id + 1, format: 'js' }.should raise_error(ActiveRecord::RecordNotFound)
      end

      it "should 404 if the place is not in the current user's group" do
        place = create(:place, person: create(:person, group: @user.group))
        -> { as_user :get, :edit, id: place.id, format: 'js' }.should raise_error(ActiveRecord::RecordNotFound)
      end
    end

    describe "PUT #update" do
      before :each do
        @place = create(:place, person: @user)
      end

      it "should not allow changing the owner of the place" do
        person = create(:person, group: @user.group)
        as_user :put, :update, id: @place.id, place: {person_id: person.id}, format: 'js'
        @place.reload.person.should == @user
      end

      context "when the place is valid" do
        before :each do
          as_user :put, :update, id: @place.id, place: {name: 'Some Name'}, format: 'js'
        end

        it "should render the update JS view" do
          response.should render_template('update')
        end

        it "should set the changed attributes on the place" do
          @place.reload.name.should == 'Some Name'
        end
      end

      context "when the place is invalid" do
        before :each do
          as_user :put, :update, id: @place.id, place: {name: nil}, format: 'js'
        end

        it "should render the update JS view" do
          response.should render_template('update')
        end

        it "should not set the changed attributes on the place" do
          @place.reload.name.should_not be_blank
        end
      end
    end

    describe "DELETE #destroy" do
      before :each do
        @place = create(:place, person: @user)
      end

      context "when the place belongs to the current user" do
        before :each do
          as_user :delete, :destroy, id: @place.id, format: 'js'
        end

        it "should render the destroy JS view" do
          response.should render_template('destroy')
        end

        it "should destroy the place" do
          Place.find_by_id(@place.id).should be_nil
        end
      end

      it "should 404 if the place does not exist" do
        -> { as_user :delete, :destroy, id: @place.id + 1, format: 'js' }.should raise_error(ActiveRecord::RecordNotFound)
      end

      it "should 404 if the place belongs to a different user" do
        place = create(:place, person: create(:person, group: @user.group))
        -> { as_user :delete, :destroy, id: place.id, format: 'js' }.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  context "with no logged-in user" do
    def should_redirect_to_login(method, *args)
      send(method, *args)
      response.should redirect_to login_url
    end

    it "should redirect to the login page with any action" do
      should_redirect_to_login :get, :index
      should_redirect_to_login :get, :show, id: 1
      should_redirect_to_login :get, :periodic
      should_redirect_to_login :post, :create
      should_redirect_to_login :get, :edit, id: 1
      should_redirect_to_login :put, :update, id: 1
      should_redirect_to_login :delete, :destroy, id: 1
    end
  end
end