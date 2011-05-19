class Place < ActiveRecord::Base
  validates_presence_of :name
  
  belongs_to :person
  
  has_many :votes
  has_many :people, :through => :votes
end
