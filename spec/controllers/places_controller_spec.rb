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