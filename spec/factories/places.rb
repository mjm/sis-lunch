require 'faker'

FactoryGirl.define do
  factory :place do
    sequence(:name) {|n| "#{Faker::Company.name}#{n}" }
    walkable true
    person

    notes { Faker::Lorem.paragraph }
    ignore { votes_count 0 }

    after :create do |place, ev|
      FactoryGirl.create_list(:vote, ev.votes_count, place: place)
    end

    trait :with_spaces do
      name { "   #{Faker::Company.name}  " }
    end
  end
end