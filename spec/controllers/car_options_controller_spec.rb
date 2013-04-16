require 'spec_helper'

describe CarOptionsController do
  context "with a logged-in user" do
    before :each do
      @user = create(:person, :with_group)
    end

    def update(*args) as_user :put, :update, *args; end

    describe "PUT #update" do
      context "when the user does not already have a car" do
        context "setting the car option to false" do
          before :each do
            update has_car: false, seats: 5, format: 'js'
          end

          it "should render the update JS view" do
            response.should render_template('update')
          end

          it "should leave the car option as false" do
            @user.reload.should_not have_car
          end

          it "should not create a car for the user" do
            @user.reload.car.should be_nil
          end
        end

        context "setting the car option to true" do
          before :each do
            @vote = create(:vote, person: @user)
            update has_car: true, seats: 5, format: 'js'
          end

          it "should render the update JS view" do
            response.should render_template('update')
          end

          it "should set the car option to true" do
            @user.reload.should have_car
          end

          it "should create a car for the user" do
            @user.reload.car.should_not be_nil
            @user.car.seats.should == 5
          end

          it "should add the user to the newly created car" do
            @user.reload.vote.car.should == @user.car
          end
        end
      end

      context "when the user already has a car" do
        before :each do
          @car = create(:car, person: @user)
          @user.reload.update_attribute 'has_car', true
          @seats = @user.car.seats
        end

        context "setting the car option to false" do
          before :each do
            update has_car: false, seats: (@seats % 10) + 1, format: 'js'
          end

          it "should render the update JS view" do
            response.should render_template('update')
          end

          it "should set the car option to false" do
            @user.reload.should_not have_car
          end

          it "should leave the existing car set" do
            @user.reload.car.should_not be_nil
          end

          it "should leave the seat count unchanged" do
            @user.reload.car.seats.should == @seats
          end
        end

        context "setting the car option to true" do
          before :each do
            @vote = create(:vote, person: @user)
            @vote.update_attribute :car, nil
            update has_car: true, seats: (@seats % 10) + 1, format: 'js'
          end

          it "should render the update JS view" do
            response.should render_template('update')
          end

          it "should leave the car option as true" do
            @user.reload.should have_car
          end

          it "should not create a new car" do
            @user.reload.car.should == @car
          end

          it "should update the seat count on the existing car" do
            @user.reload.car.seats.should == (@seats % 10) + 1
          end

          it "should not move the user into the car" do
            @user.reload.vote.car.should be_nil
          end
        end
      end
    end
  end

  context "with no logged-in user" do
    it "should redirect to the login page with any action" do
      should_redirect_to_login :put, :update
    end
  end
end