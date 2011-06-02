class Car < ActiveRecord::Base
  belongs_to :person

  def seats_left(place)
    seats - place.votes_for_car(self).size
  end
end
