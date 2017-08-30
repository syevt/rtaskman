FactoryGirl.define do
  factory :project do
    name { Faker::Lorem.sentence }
  end
end
