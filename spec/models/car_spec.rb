require 'spec_helper'

describe Car do
  fixtures :all

  before :each do
    @car = cars(:matts_car)
  end

  context "validating seats" do
    before :each do
      @car = Car.new person: people(:bowden), seats: 5
    end

    it "should allow a car with a valid number of seats" do
      @car.save.should be_true

      @car.seats = 1
      @car.save.should be_true

      @car.seats = 10
      @car.save.should be_true
    end

    it "should not allow a car with no seats" do
      @car.seats = 0
      @car.save.should be_false
    end

    it "should not allow a car with negative number of seats" do
      @car.seats = -3
      @car.save.should be_false
    end

    it "should not allow a car with too many seats" do
      @car.seats = 11
      @car.save.should be_false
    end
  end

  it "should count the number of seats left in the car" do
    @car.seats_left.should == @car.seats - 2
    cars(:jessies_car).seats_left.should == cars(:jessies_car).seats
  end
end