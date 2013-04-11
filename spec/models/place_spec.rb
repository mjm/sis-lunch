require 'spec_helper'

describe Place do
  fixtures :all

  before :each do
    @place = Place.new name: 'Some place', person: people(:matt)
  end

  context "validating name" do
    it "should accept a unique name" do
      @place.save.should be_true
    end

    it "should reject a nil name" do
      @place.name = nil
      @place.save.should be_false
    end

    it "should reject a blank name" do
      @place.name = ""
      @place.save.should be_false
    end

    it "should reject a name with only spaces" do
      @place.name = "   "
      @place.save.should be_false
    end

    it "should reject a name that already exists" do
      @place.save!

      @place = Place.new name: 'Some place', person: people(:matt)
      @place.save.should be_false
    end

    it "should reject a name that exists differing only by spaces" do
      @place.save!

      @place = Place.new name: '  Some place   ', person: people(:matt)
      @place.save.should be_false
    end

    it "should strip spaces on save" do
      @place.name = "  Something  "
      @place.save!

      @place.reload.name.should == "Something"
    end
  end

  it "should choose most popular place by vote count" do
    Place.most_popular.should == places(:grubhub)
  end

  context "formatted notes" do
    it "should be empty if no notes are set" do
      @place.formatted_notes.should == ""
    end

    it "should be HTML if some notes are set" do
      @place.notes = "Here are **some** notes."
      @place.formatted_notes.strip.should == "<p>Here are <strong>some</strong> notes.</p>"
    end
  end

  it "should find the vote for a given person" do
    places(:grubhub).vote_for(people(:matt)).should == votes(:matt_for_gh)
    places(:grubhub).vote_for(people(:jessie)).should == votes(:jessie_for_gh)
    places(:jimmy_johns).vote_for(people(:burrito)).should == votes(:burrito_for_jj)

    places(:grubhub).vote_for(people(:burrito)).should be_nil
  end

  context "car owners" do
    before :each do
      @place = places(:grubhub)
    end

    it "should contain a key for each car owner" do
      @place.car_owners.should have_key(people(:matt))
      @place.car_owners.should have_key(people(:jessie))
      @place.car_owners.should_not have_key(people(:bowden))
    end

    it "should contain a nil key if a person is not assigned a car" do
      @place.car_owners.should have_key(nil)
    end

    it "should not contain a nil key if everyone is assigned a car" do
      @place.vote_for(people(:bowden)).car = cars(:jessies_car)

      @place.car_owners.should_not have_key(nil)
    end
  end
end