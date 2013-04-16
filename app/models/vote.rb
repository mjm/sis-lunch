class SeatCountValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    # don't care if we were already in the car
    return if value and value.votes.include?(record)

    if value and value.seats_left < 1
      record.errors.add attribute, "has no more seats available." #TODO i18n
    end
  end
end

class Vote < ActiveRecord::Base
  belongs_to :place, counter_cache: true
  belongs_to :person
  belongs_to :car

  validates :person_id, presence: true, uniqueness: true # TODO be able to store history
  validates :place, presence: true
  validates :car, seat_count: true

  validates_each :person do |record, attribute, value|
    next if value.nil? or record.place.nil?

    if value.group != record.place.person.group
      record.errors.add attribute, "must be in the same group as the place voted for."
    end
  end

  before_create :assign_car_owner

  class << self
    def update_comment(id, person, comment)
      vote = first(conditions: {id: id, person_id: person.id})
      raise ActiveRecord::RecordNotFound, 'could not find vote' unless vote

      vote.comment = comment
      vote.save

      vote
    end

    def register(person, place_id, car_id)
      destroy_all person_id: person.id

      vote = new(person: person)
      vote.place_id = place_id
      vote.car_id = car_id
      vote.save

      vote
    end
  end

  private
    def assign_car_owner
      self.car ||= person.car if person.has_car?
    end
end
