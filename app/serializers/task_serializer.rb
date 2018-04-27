class TaskSerializer < ActiveModel::Serializer
  attributes :id, :project_id, :content, :done, :deadline, :priority
end
