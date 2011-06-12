require 'digest'

class Person < ActiveRecord::Base
  has_one :vote, :dependent => :destroy
  has_one :place, :through => :vote
  has_one :car
  
  validates :name, :presence => true, :uniqueness => true
  validates :password, :confirmation => true
  
  before_validation { write_attribute :name, name.strip }
  before_create :hash_password
  
  def self.hash_password(pass)
    Digest::SHA2.hexdigest("--max-poops-2342arstarts-#{pass}--")
  end
  
  def self.authenticate(name, password)
    find_by_name_and_password(name, hash_password(password))
  end
  
  private
    def hash_password
      write_attribute 'password', self.class.hash_password(self.password)
      @password_confirmation = nil
    end
    
end