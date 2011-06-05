class AddTimeToLeave < ActiveRecord::Migration
  def change
    add_column :places, :leaving_at, :time
  end
end
