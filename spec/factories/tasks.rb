ProjectTask = Struct.new :content, :deadline, :done

FactoryGirl.define do
  factory :project_task do
    content { Faker::Hipster.sentence }
    sequence(:deadline) { |n| DateTime.now + n.days }
    done { [true, false].sample }
  end
end
