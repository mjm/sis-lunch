class AddNotesForPlaces < ActiveRecord::Migration
  def change
  	add_column :places, :notes, :string
  end
end
