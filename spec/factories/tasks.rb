FactoryGirl.define do
  factory :task do
    project nil
    done false
    content "MyString"
    deadline "2018-01-30"
  end
end
