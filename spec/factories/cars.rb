FactoryGirl.define do
  factory :car do
    seats { rand(10) + 1 }

    trait :with_person do
      person
    end
  end
end