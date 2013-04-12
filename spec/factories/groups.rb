require 'faker'

FactoryGirl.define do
  factory :group do |g|
    name { Faker::Company.name }
    association :created_by, factory: :person
  end
end