class Place < ActiveRecord::Base
  validates_presence_of :name
  
  belongs_to :person
  
  has_many :votes, :dependent => :destroy
  has_many :people, :through => :votes
  
  def vote_for(person)
    votes.detect {|v| v.person == person }
  end
  
  def num_seats
    people.inject(0) do |seats, p|
      if p.has_car?
        seats + p.car.seats
      else
        seats
      end
    end 
  end
end
