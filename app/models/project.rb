require_relative 'schemas/tasks'

class Project < ApplicationRecord
  belongs_to :user

  validates :name,
            presence: true,
            format: { with: /\A[\p{Alnum}.\s]+\z/ }

  validates :tasks, json: {
    message: ->(errors) { errors },
    schema: TASKS_SCHEMA
  }
end
