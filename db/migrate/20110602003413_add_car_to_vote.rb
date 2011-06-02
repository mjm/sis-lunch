class AddCarToVote < ActiveRecord::Migration
  def change
    add_column :votes, :car_id, :integer
  end
end
