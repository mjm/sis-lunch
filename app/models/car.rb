class Car < ActiveRecord::Base
  belongs_to :person
  has_many :votes, :dependent => :nullify
  
  validates :seats, :inclusion => { :in => 1..10, :message => 'must be between 1 and 10.' }

  def seats_left(place)
    seats - place.votes_for_car(self).size
  end
end
