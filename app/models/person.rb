require 'digest'

class Person < ActiveRecord::Base
  has_secure_password
  validates :password, presence: { on: :create }

  has_one :vote, dependent: :destroy
  has_one :place, through: :vote
  has_one :car
  has_one :membership # for now, just one
  has_one :group, through: :membership
  
  has_many :places
  
  validates :name, presence: true, uniqueness: true
  
  before_validation { write_attribute :name, name.strip }
end