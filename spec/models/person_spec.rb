require 'spec_helper'

describe Person do
  before :each do

    @person = Person.new name: 'Some name', password: 'pass', password_confirmation: 'pass'
  end

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

end