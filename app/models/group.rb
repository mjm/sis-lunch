class Group < ActiveRecord::Base
  belongs_to :created_by, class_name: "Person"
  has_many :memberships
  has_many :people, through: :memberships
end
