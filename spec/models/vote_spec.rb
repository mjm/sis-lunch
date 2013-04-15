require 'spec_helper'

describe Vote do
  it "should not be valid without a place" do
    build(:vote, place: nil).should_not be_valid
  end

  it "should not be valid without a person" do
    build(:vote, person: nil).should_not be_valid
  end

  context "car" do
    it "should be filled in with the person's car if they have one" do
      person = create(:person, :with_car)
      create(:vote, person: person).reload.car.should == person.car
    end

    it "should remain unchanged if the car is already set" do
      car = create(:car, :with_person, seats: 5)
      create(:vote, person: create(:person, :with_car), car: car).reload.car.should == car
      create(:vote, person: create(:person), car: car).reload.car.should == car
    end

    it "should be unfilled if the person has no car" do
      create(:vote).reload.car.should be_nil
    end
  end

  it "should not allow multiple votes from the same person" do
    vote = create(:vote)
    build(:vote, person: vote.person).should_not be_valid
  end

  it "should not allow a person to vote for a place in a different group" do
    person = create(:person, :with_group)
    place = create(:place, person: create(:person, :with_group))
    build(:vote, person: person, place: place).should_not be_valid
  end

  it "should update the vote count in the associated place" do
    place = create(:place)
    place.votes_count.should == 0

    create(:vote, place: place)
    place.reload.votes_count.should == 1

    create(:vote, place: place)
    place.reload.votes_count.should == 2
  end

  context "seat count" do
    before :each do
      @car = create(:car, :with_person, seats: 3)
    end

    context "when seats are available" do
      it "should allow adding a vote" do
        build(:vote, car: @car).should be_valid
      end
    end

    context "when no seats are available" do
      before :each do
        create_list(:vote, @car.seats, car: @car)
      end

      it "should reject adding a vote from a new person" do
        build(:vote, car: @car).should_not be_valid
      end

      it "should allow updating an existing vote" do
        vote = @car.votes.first
        vote.should be_valid

        vote.comment = "something!"
        vote.should be_valid
      end
    end
  end
end