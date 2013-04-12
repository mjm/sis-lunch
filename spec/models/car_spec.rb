require 'spec_helper'

describe Car do
  it "should not allow a car with no person" do
    build(:car).should_not be_valid
  end

  context "validating seats" do
    it "should allow a car with a valid number of seats" do
      build(:car, :with_person).should be_valid
    end

    it "should not allow a car with no seats" do
      build(:car, :with_person, seats: 0).should_not be_valid
    end

    it "should not allow a car with negative number of seats" do
      build(:car, :with_person, seats: -3).should_not be_valid
    end

    it "should not allow a car with too many seats" do
      build(:car, :with_person, seats: 11).should_not be_valid
    end

    it "should not allow a car with nil seats" do
      build(:car, :with_person, seats: nil).should_not be_valid
    end
  end

  it "should count the number of seats left in the car" do
    car = create(:car, :with_person, seats: 5)
    car.person.place = create(:place)
    car.seats_left.should == car.seats

    create_list(:vote, 3, place: car.person.place, car: car)
    car.seats_left.should == car.seats - 3
  end
end