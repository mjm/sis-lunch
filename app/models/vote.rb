class Vote < ActiveRecord::Base
  belongs_to :place
  belongs_to :person
  
  validates_uniqueness_of :person_id # TODO be able to store history
end
