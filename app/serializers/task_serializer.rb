class TaskSerializer < ActiveModel::Serializer
  attributes :id, :content, :done, :deadline, :priority
end
