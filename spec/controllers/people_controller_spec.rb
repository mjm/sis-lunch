require 'spec_helper'

describe PeopleController do
  context "with a logged-in user" do
    before :each do
      @user = create(:person, :with_group)
    end

    describe "GET #edit" do
      it "should render the edit view if correct id is given" do
        as_user :get, :edit, id: @user.id
        response.should render_template('edit')
      end

      it "should redirect to the correct edit page for incorrect ids" do
        as_user :get, :edit, id: @user.id+1
        response.should redirect_to(edit_person_url(@user.id))
      end
    end

    describe "PUT #update" do
      it "should raise an error if the id doesn't match the current user" do
        -> {
          as_user :put, :update, id: @user.id+1
        }.should raise_error
      end

      it "should redirect to the places page with valid input" do
        as_user :put, :update, id: @user.id, person: {name: 'Something'}
        response.should redirect_to(places_url)
      end

      it "should update the user's displayed name" do
        as_user :put, :update, id: @user.id, person: {name: 'Dis Guy'}
        @user.reload.name.should == 'Dis Guy'
      end

      it "should leave the password alone if both fields are blank" do
        digest = @user.password_digest
        as_user :put, :update, id: @user.id, person: {password: '', password_confirmation: ''}

        @user.reload.password_digest.should == digest
      end

      it "should update the password if password and confirmation match" do
        digest = @user.password_digest
        as_user :put, :update, id: @user.id, person: {password: 'thing', password_confirmation: 'thing'}

        @user.reload.password_digest.should_not == digest
      end

      it "should redisplay the edit page if the password and confirmation don't match" do
        digest = @user.password_digest
        as_user :put, :update, id: @user.id, person: {password: 'thing', password_confirmation: 'guy'}

        response.should render_template('edit')
        @user.reload.password_digest.should == digest
      end

      it "should redisplay the edit page if the name is invalid" do
        as_user :put, :update, id: @user.id, person: {name: ''}

        response.should render_template('edit')
        @user.reload.name.should_not == ''
      end
    end

    describe "GET #logout" do
      it "should unset the current user in the session" do
        as_user :get, :logout
        session[:user_id].should be_nil
      end

      it "should redirect to the login page" do
        as_user :get, :logout
        response.should redirect_to(login_url)
      end
    end
  end

  context "with no logged-in user" do
    it "should redirect to the login page for the edit and update actions" do
      should_redirect_to_login :get, :edit
      should_redirect_to_login :put, :update, id: 1
    end

    describe "GET #new" do
      it "should render the new view" do
        get :new
        response.should render_template('new')
      end

      it "should build a new person for rendering" do
        get :new
        assigns(:person).should_not be_nil
      end
    end

    describe "POST #create" do
      it "should render the new template if the person is invalid" do
        post :create, person: {name: ''}
        response.should render_template('new')
      end

      context "with a valid person" do
        before :each do
          @request.remote_addr = '123.123.123.123'
          person = {
            name: 'Guy',
            password: 'passward',
            password_confirmation: 'passward'
          }
          post :create, person: person
        end

        it "should redirect to the places page" do
          response.should redirect_to(places_url)
        end

        it "should create the new person" do
          Person.find_by_name('Guy').should_not be_nil
        end

        it "should make the new user be logged-in" do
          session[:user_id].should_not be_nil
        end

        it "should set the signup IP address" do
          Person.find_by_name('Guy').signup_ip.should == '123.123.123.123'
        end
      end
    end

    describe "GET #login" do
      it "should render the login view" do
        get :login
        response.should render_template('login')
      end
    end

    describe "POST #login" do
      before :each do
        @user = create(:person, :with_group)
      end

      it 'should re-render the login form if the user does not exist' do
        post :login, name: 'somebody', password: 'who_cares'
        response.should render_template('login')
        flash[:error].should_not be_nil
      end

      it 'should re-render the login form if the password does not match' do
        post :login, name: @user.name, password: 'who_doesnt_care'
        response.should render_template('login')
        flash[:error].should_not be_nil
      end

      context 'when the password is correct' do
        before :each do
          @request.remote_addr = '123.123.123.123'
          post :login, name: @user.name, password: 'who_cares'
        end

        it 'should redirect to the places page' do
          response.should redirect_to(places_url)
        end

        it 'should set the current user in the session' do
          session[:user_id].should == @user.id
        end

        it "should save the user's IP as the login IP" do
          @user.reload.login_ip.should == '123.123.123.123'
        end
      end
    end
  end
end