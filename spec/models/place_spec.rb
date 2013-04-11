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
end