class AddPlacePerson < ActiveRecord::Migration
  def self.up
    add_column :places, :person_id, :integer
  end

  def self.down
    remove_column :places, :person_id
  end
end
