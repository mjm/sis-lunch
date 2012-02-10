collection @places

attributes :id, :name, :walkable

node :user_vote_id do |p|
  p.vote_for(@current_user).try(:id)
end

node :total_votes do |p|
  p.votes.count
end