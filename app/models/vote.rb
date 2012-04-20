class SeatCountValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    # don't care if we were already in the car
    return if value and value.votes.include?(record)

    if value and value.seats_left(record.place) < 1
      record.errors.add attribute, "has no more seats available." #TODO i18n
    end
  end
end

class Vote < ActiveRecord::Base
  belongs_to :place, counter_cache: true
  belongs_to :person
  belongs_to :car

  validates :person_id, :uniqueness => true # TODO be able to store history
  validates :car, :seat_count => true

  before_create :assign_car_owner

  private
    def assign_car_owner
      self.car = person.car if person.has_car?
    end
end
