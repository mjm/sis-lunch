class AddVoteCount < ActiveRecord::Migration
  def change
    add_column :places, :votes_count, :integer, :default => 0

    Place.reset_column_information
    Place.all.each do |p|
      Place.update_counters p.id, votes_count: p.votes.count
    end
  end
end
