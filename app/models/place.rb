require 'rdiscount'

class Place < ActiveRecord::Base
  default_scope order('created_at')
  
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

  def votes_for_car(car)
    votes.select {|v| v.car == car }
  end
  
  def as_json(options = nil)
    json = super
    
    json['place']['vote_total'] = votes.count
    
    if walkable?
      json['place']['votes'] = votes.as_json(include: :person, root: false)
    else
      json['place']['cars'] = []
      car_owners.each do |p, v|
        json['place']['cars'] << {'owner' => p.as_json(root: false), 'votes' => v.as_json(include: :person, root: false)}
      end
    end
    
    json
  end

end
