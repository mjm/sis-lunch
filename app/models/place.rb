require 'rdiscount'

class Place < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true
  
  belongs_to :person
  
  has_many :votes, :dependent => :destroy
  has_many :people, :through => :votes
  
  before_validation { write_attribute :name, name.strip }
  
  def formatted_notes
  	notes and Markdown.new(notes).to_html.html_safe or ""
  end
  
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
  
  def car_owners
    people.select(&:has_car?) + (votes_for_car(nil).empty? and [] or [nil])
  end

  def votes_for_car(car)
    votes.select {|v| v.car == car }
  end

end
