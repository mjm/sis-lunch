require 'spec_helper'

describe Place do
  it "should not be valid without a person" do
    build(:place, person: nil).should_not be_valid
  end

  context "validating name" do
    it "should accept a unique name" do
      build(:place).should be_valid
    end

    it "should reject a nil name" do
      build(:place, name: nil).should_not be_valid
    end

    it "should reject a blank name" do
      build(:place, name: "").should_not be_valid
    end

    it "should reject a name with only spaces" do
      build(:place, name: "    ").should_not be_valid
    end

    it "should reject a name that already exists" do
      place = create(:place)

      build(:place, name: place.name).should_not be_valid
    end

    it "should reject a name that exists differing only by spaces" do
      place = create(:place)

      build(:place, name: "   #{place.name}   ").should_not be_valid
    end

    it "should strip spaces on save" do
      place = create(:place, :with_spaces)
      place.reload.name.should == place.name.strip
    end
  end

  describe "most popular" do
    it "should choose most popular place by vote count" do
      create(:place, votes_count: 2)
      create(:place, votes_count: 5)
      create(:place, votes_count: 1)

      Place.most_popular.votes_count.should == 5
    end

    it "should choose no place when there are no places" do
      Place.most_popular.should be_nil
    end

    it "should choose no place when there are places but no votes" do
      create_list(:place, 3)
      Place.most_popular.should be_nil
    end
  end

  context "formatted notes" do
    it "should be empty if no notes are set" do
      build(:place, notes: nil).formatted_notes.should == ""
    end

    it "should be HTML if some notes are set" do
      build(:place, notes: "Here are **some** notes.").formatted_notes.strip.should == "<p>Here are <strong>some</strong> notes.</p>"
    end
  end

  context "car owners" do
    before :each do
      @place = create(:place)

      @person1 = create(:person, :with_car, place: @place)
      @person2 = create(:person, :with_car, place: @place)
      @person3 = create(:person, place: @place)

      @person1.car.update_attribute(:seats, 2)
      @person1.vote.update_attribute(:car, @person1.car)
      @person2.vote.update_attribute(:car, @person1.car)
    end

    it "should contain a key for each car owner" do
      @place.car_owners.should have_key(@person1)
      @place.car_owners.should have_key(@person2)
      @place.car_owners.should_not have_key(@person3)
    end

    it "should contain a nil key if a person is not assigned a car" do
      @place.car_owners.should have_key(nil)
    end

    it "should not contain a nil key if everyone is assigned a car" do
      @person3.vote.update_attribute :car, @person2.car
      @place.car_owners.should_not have_key(nil)
    end
  end
end