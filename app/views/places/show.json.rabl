object @place

attributes :id, :name, :notes, :walkable

node :user_vote_id do |p|
  p.vote_for(@current_user).try(:id)
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