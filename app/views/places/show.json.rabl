object @place

attributes :id, :name, :notes, :walkable

node :user_vote_id do |p|
  if p.people.include? @current_user
    @current_user.vote.id
  else
    nil
  end
end

if @place.walkable?
  child :votes do
    child :person do
      attributes :name
    end
  end
else
  child :cars => :cars do
    child :owner => :owner do
      attributes :name
    end
    child :votes do
      child :person do
        attributes :name
      end
    end
  end
end