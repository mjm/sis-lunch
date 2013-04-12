require 'faker'

FactoryGirl.define do
  factory :person do |p|
    p.name { Faker::Name.first_name }
    p.password "who_cares"
    p.password_confirmation "who_cares"
    p.has_car false

    trait :with_car do |p|
      p.has_car true
      p.car
    end

    trait :with_spaces do |p|
      p.name { "   #{Faker::Name.first_name}    " }
    end

    trait :with_group do |p|
      group
    end
  end
end