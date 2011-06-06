class SeatCountValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value and value.seats_left(record.place) < 1
      record.errors.add attribute, "has no more seats available."
    end
  end
end

class Vote < ActiveRecord::Base
  belongs_to :place
  belongs_to :person
  belongs_to :car
  
  validates :person_id, :uniqueness => true # TODO be able to store history
  validates :car, :seat_count => true
end
