require 'rdiscount'

PlaceCar = Struct.new(:owner, :votes)

class Place < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :person, presence: true

  belongs_to :person

  has_many :votes, dependent: :destroy
  has_many :people, through: :votes

  before_validation { write_attribute :name, name.try(:strip) }

  class << self
    def most_popular
      self.where('votes_count > 0').order('votes_count desc').first
    end
  end

  def formatted_notes
    notes and Markdown.new(notes).to_html.html_safe or ""
  end

  def car_owners
    owners = {}
    people.select(&:has_car?).each do |person|
      owners[person] = []
    end
    owners[nil] = []

    votes.each do |vote|
    	car_owner = vote.car.try(:person)
    	car_owner = nil unless owners.has_key? car_owner
    	owners[car_owner] << vote
    end

    owners.delete(nil) if owners[nil].empty?
  	owners
  end

  # This is used for the JSON API
  def cars
    cars = []
    car_owners.each do |p, v|
      cars << PlaceCar.new(p, v)
    end
    cars
  end

end
