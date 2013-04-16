class Person < ActiveRecord::Base
  has_secure_password
  validates :password, presence: { on: :create }

  has_one :vote, dependent: :destroy
  has_one :place, through: :vote
  has_one :car
  has_one :membership # for now, just one
  has_one :group, through: :membership
  
  has_many :places
  has_many :visible_places, through: :group, source: :places, order: 'votes_count desc'
  
  validates :name, presence: true, uniqueness: true
  
  before_validation { write_attribute :name, name.try(:strip) }
  
  before_create :ensure_group

  def update_car_options(options = {})
    self.has_car = options[:has_car]

    if has_car
      self.car ||= build_car
      car.seats = options[:seats]
      return false unless car.save

      if has_car_changed? and vote and vote.car.nil?
        vote.update_attribute :car, car
      end
    end

    save
  end
  
  private
    def ensure_group
      self.group = Group.first unless group
    end
end