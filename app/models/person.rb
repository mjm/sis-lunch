require 'digest'

class Person < ActiveRecord::Base
  has_one :place, :through => :votes
  
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_confirmation_of :password
  
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