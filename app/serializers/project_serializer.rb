class ProjectSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :name
  has_many :tasks
end
