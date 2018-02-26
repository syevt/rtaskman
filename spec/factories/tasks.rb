FactoryGirl.define do
  factory :task do
    content { Faker::Lorem.sentence(3, false, 2) }
    project
  end
end
