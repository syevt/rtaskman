FactoryGirl.define do
  factory :project do
    name { Faker::Lorem.sentence(3) }
    user

    factory :project_with_tasks do
      transient { tasks_count 2 }

      before(:create) do |project, evaluator|
        project.tasks << build_list(:task, evaluator.tasks_count)
      end
    end
  end
end
