require 'spec_helper'

describe Person do
  before :each do
    @person = Person.new name: 'Some name', password: 'pass', password_confirmation: 'pass'
  end

  context "validating name" do
    it "should accept a unique name" do
      @person.save.should be_true
    end

    it "should reject a nil name" do
      @person.name = nil
      @person.save.should be_false
    end

    it "should reject a blank name" do
      @person.name = ""
      @person.save.should be_false
    end

    it "should reject a name with only spaces" do
      @person.name = "   "
      @person.save.should be_false
    end

    it "should reject a name that already exists" do
      @person.save!

      @person = Person.new name: 'Some name', password: 'things', password_confirmation: 'things'
      @person.save.should be_false
    end

    it "should reject a name that exists differing only by spaces" do
      @person.save!

      @person = Person.new name: '  Some name   ', password: 'things', password_confirmation: 'things'
      @person.save.should be_false
    end

    it "should strip spaces on save" do
      @person.name = "  Something  "
      @person.save!

      @person.reload.name.should eq("Something")
    end
  end

  context "group" do
    before :each do
      @group = Group.create! name: 'A group'
    end

    it "should be assigned on create if not given one" do
      @person.save!

      @person.reload.group.should_not be_nil
    end

    it "should be left alone on create if already set" do
      @person.group = @group
      @person.save!

      @person.reload.group.should eq(@group)
    end
  end

end