require 'faker'

FactoryGirl.define do
  factory :place do
    sequence(:name) {|n| "#{Faker::Company.name}#{n}" }
    walkable true
    person

    notes { Faker::Lorem.paragraph }
    ignore { votes_count 0 }

    after :create do |place, ev|
      ev.votes_count.times do |i|
        FactoryGirl.create(:vote, place: place, person: FactoryGirl.create(:person, group: place.person.group))
      end
    end

    trait :with_spaces do
      name { "   #{Faker::Company.name}  " }
    end
  end
end