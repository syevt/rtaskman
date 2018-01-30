class TaskSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :content, :done, :deadline, :priority
end
