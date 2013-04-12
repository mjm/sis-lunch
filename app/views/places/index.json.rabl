collection @places

attributes :id, :name, :walkable

node :user_vote_id do |p|
  if p.people.include? @current_user
    @current_user.vote.id
  else
    nil
  end
end

node :total_votes do |p|
  p.votes.count
end