class AddVoteComments < ActiveRecord::Migration
  def change
    add_column :votes, :comment, :string
  end
end
