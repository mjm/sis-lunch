class Group < ActiveRecord::Base
  belongs_to :created_by, class_name: "Person"
  has_many :memberships
  has_many :people, through: :memberships
  
  # Group places are all the places created by people in the group
  has_many :places, through: :people, source: :places 
end
