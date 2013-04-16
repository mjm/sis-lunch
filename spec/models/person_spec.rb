require 'spec_helper'

describe Person do
  context "validating name" do
    it "should accept a unique name" do
      build(:person).should be_valid
    end

    it "should reject a nil name" do
      build(:person, name: nil).should_not be_valid
    end

    it "should reject a blank name" do
      build(:person, name: "").should_not be_valid
    end

    it "should reject a name with only spaces" do
      build(:person, name: "     ").should_not be_valid
    end

    it "should reject a name that already exists" do
      person = create(:person)

      build(:person, name: person.name).should_not be_valid
    end

    it "should reject a name that exists differing only by spaces" do
      person = create(:person)
      build(:person, name: "  #{person.name}   ").should_not be_valid
    end

    it "should strip spaces on save" do
      person = create(:person, :with_spaces)
      person.reload.name.should == person.name.strip
    end
  end

  context "group" do
    before :each do
      @group = create(:group)
    end

    it "should be assigned on create if not given one" do
      create(:person).reload.group.should == @group
    end

    it "should be left alone on create if already set" do
      person = build(:person, :with_group)
      group = person.group

      person.save!
      person.reload.group.should eq(group)
    end
  end

  describe "car options" do
    context "when the person does not have a car" do
      before :each do
        @person = create(:person, :with_group)
      end

      it "should be able to set the car option to false" do
        @person.update_car_options(has_car: false, seats: 5)
        @person.reload.should_not have_car
        @person.car.should be_nil
      end

      it "should be able to set the car option to true" do
        @person.update_car_options(has_car: true, seats: 5)
        @person.reload.should have_car
        @person.car.should_not be_nil
        @person.car.seats.should == 5
      end
    end

    context "when the person already has a car" do
      before :each do
        @person = create(:person, :with_car, :with_group)
        @seats = @person.car.seats
        @new_seats = (@seats % 10) + 1
      end

      it "should be able to set the car option to true" do
        @person.update_car_options(has_car: true, seats: @new_seats)
        @person.reload.should have_car
        @person.car.should_not be_nil
        @person.car.seats.should == @new_seats
      end

      it "should be able to set the car option to false" do
        @person.update_car_options(has_car: false, seats: @new_seats)
        @person.reload.should_not have_car
        @person.car.should_not be_nil
        @person.car.seats.should == @seats
      end
    end

    context "when the number of seats is not valid" do
      it "should leave the car option as it was originally" do
        person = create(:person, :with_group)
        person.update_car_options(has_car: true, seats: -1)

        person.reload.should_not have_car
        person.car.should be_nil
      end

      it "should not update the number of seats in the car" do
        person = create(:person, :with_car, :with_group)
        person.update_car_options(has_car: true, seats: -1)

        person.reload.should have_car
        person.car.should_not be_nil
        person.car.seats.should_not == -1
      end
    end
  end

end