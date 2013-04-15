require 'spec_helper'
require 'faker'

describe VotesController do
  context "with a logged-in user" do
    before :each do
      @user = create(:person, :with_group)
      @place = create(:place, person: create(:person, :with_car, group: @user.group), walkable: false)
      @car = @place.person.car
    end

    def as_user(method, action, params = nil, session = nil, flash = nil)
      session ||= {}
      session = session.merge({user_id: @user.id})

      send(method, action, params, session, flash)
    end

    describe "POST #create" do
      context "when the vote is valid" do
        before :each do
          as_user :post, :create, place: @place.id, car: @car.id, format: 'js'
        end

        it "should render the create JS view" do
          response.should render_template('create')
        end

        it "should create the vote for the current user" do
          @user.reload.vote.should_not be_nil
          @user.vote.place.should == @place
          @user.vote.car.should == @car
        end
      end

      context "when the vote is invalid" do
        before :each do
          create(:vote, person: @user, place: @place)
          place = create(:place, person: create(:person, :with_group))
          as_user :post, :create, place: place.id, format: 'js'
        end

        it "should render the create JS view" do
          response.should render_template('create')
        end

        it "should not create the vote and destroy the old vote" do
          @user.reload.vote.should be_nil
        end
      end
    end

    describe "GET #edit" do
      before :each do
        @vote = create(:vote, person: @user)
      end

      it "should render the edit view" do
        as_user :get, :edit, id: @vote.id, format: 'js'
        response.should render_template('edit')
      end

      it "should 404 if the vote ID does not exist" do
        -> { as_user :get, :edit, id: @vote.id + 1, format: 'js' }.should raise_error(ActiveRecord::RecordNotFound)
      end

      it "should 404 if the vote does not belong to the current user" do
        vote = create(:vote, person: create(:person, group: @user.group))
        -> { as_user :get, :edit, id: vote.id, format: 'js' }.should raise_error(ActiveRecord::RecordNotFound)
      end
    end

    describe "PUT #update" do
      before :each do
        @vote = create(:vote, person: @user)
      end

      it "should not allow changing the place of the vote" do
        as_user :put, :update, id: @vote.id, vote: {place_id: @place.id}, format: 'js'
        @vote.reload.place.should_not == @place
      end

      it "should not allow changing the owner of the vote" do
        as_user :put, :update, id: @vote.id, vote: {person_id: create(:person, group: @user.group).id}, format: 'js'
        @vote.reload.person.should == @user
      end

      it "should not allow changing the car of the vote" do
        as_user :put, :update, id: @vote.id, vote: {car_id: create(:car, :with_person).id}, format: 'js'
        @vote.reload.car.should be_nil
      end

      it "should render the update JS view" do
        as_user :put, :update, id: @vote.id, vote: {comment: Faker::Lorem.sentence}, format: 'js'
        response.should render_template('update')
      end

      it "should allow changing the comment on the vote" do
        new_text = Faker::Lorem.sentence
        as_user :put, :update, id: @vote.id, vote: {comment: new_text}, format: 'js'
        @vote.reload.comment.should == new_text
      end

      it "should 404 if the vote ID does not exist" do
        -> {
          as_user :put, :update, id: @vote.id + 1, vote: {comment: Faker::Lorem.sentence}, format: 'js'
        }.should raise_error(ActiveRecord::RecordNotFound)
      end

      it "should 404 if the vote does not belong to the current user" do
        vote = create(:vote, person: create(:person, group: @user.group))
        -> {
          as_user :put, :update, id: vote.id, vote: {comment: Faker::Lorem.sentence}, format: 'js'
        }.should raise_error(ActiveRecord::RecordNotFound)
      end
    end

    describe "DELETE #destroy" do
      before :each do
        @vote = create(:vote, person: @user)
      end

      context "when the vote belongs to the current user" do
        before :each do
          as_user :delete, :destroy, id: @vote.id, format: 'js'
        end

        it "should render the destroy JS view" do
          response.should render_template('destroy')
        end

        it "should destroy the vote" do
          Vote.find_by_id(@vote.id).should be_nil
          @user.reload.vote.should be_nil
        end
      end

      it "should 404 if the vote does not exist" do
        -> { as_user :delete, :destroy, id: @vote.id + 1, format: 'js' }.should raise_error(ActiveRecord::RecordNotFound)
      end

      it "should 404 if the vote belongs to a different user" do
        vote = create(:vote, person: create(:person, group: @user.group))
        -> { as_user :delete, :destroy, id: vote.id, format: 'js' }.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  context "with no logged-in user" do
    def should_redirect_to_login(method, *args)
      send(method, *args)
      response.should redirect_to login_url
    end

    it "should redirect to the login page with any action" do
      should_redirect_to_login :post, :create
      should_redirect_to_login :get, :edit, id: 1
      should_redirect_to_login :put, :update, id: 1
      should_redirect_to_login :delete, :destroy, id: 1
    end
  end
end