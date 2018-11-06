FactoryGirl.define do
  factory :task do
    content { Faker::Lorem.sentence(3, false, 2) }
    sequence(:priority) { |n| n }
  end
end
