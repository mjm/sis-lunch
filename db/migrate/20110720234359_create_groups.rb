class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.integer :created_by_id
      t.timestamps
    end
  end
end
