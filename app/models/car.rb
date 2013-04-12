class Car < ActiveRecord::Base
  belongs_to :person
  has_one :place, through: :person
  has_many :votes, dependent: :nullify
  
  validates :person, presence: true
  validates :seats, inclusion: { in: 1..10 }

  def seats_left
    seats - votes.count
  end
end
