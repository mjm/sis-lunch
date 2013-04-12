FactoryGirl.define do
  factory :vote do
    person
    place
    comment { Faker::Lorem.sentence }
  end
end