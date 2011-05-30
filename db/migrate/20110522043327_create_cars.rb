class CreateCars < ActiveRecord::Migration
  def self.up
    create_table :cars do |t|
      t.integer :person_id
      t.integer :seats

      t.timestamps
    end
  end

  def self.down
    drop_table :cars
  end
end
