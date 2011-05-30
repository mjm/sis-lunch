class PersonHasCar < ActiveRecord::Migration
  def change
    add_column "people", "has_car", :boolean
  end
end
