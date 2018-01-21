require 'json-schema'

class Project < ApplicationRecord
  # TASKS_SCHEMA = Rails.root.join('app', 'models', 'schemas', 'tasks_schema.json')
  tasks_schema = {
    "type" => "array",
    "items" => {
      "type" => ["object", "null"],
      "required" => ["done", "content", "deadline"],
      "properties" => {
        "done" => { "type" => "boolean" },
        "content" => {
          "type" => "string",
          "format" => "task-content-format"
        },
        "deadline" => {
          "type" => "string",
          "format" => "date"
        }
      }
    },
    "minItems" => 0
  }

  belongs_to :user

  validates :name,
            presence: true,
            format: { with: /\A[\p{Alnum}.\s]+\z/ }

  validates :tasks, json: {
    message: ->(errors) { errors },
    # json: { schema: TASKS_SCHEMA }
    schema: tasks_schema
  }

  task_content_format = lambda { |value|
    unless value =~ /\A[\p{Alnum}.\s]+\z/
      raise JSON::Schema::CustomFormatError.new('has invalid format')
    end
  }

  JSON::Validator.register_format_validator(
    'task-content-format', task_content_format
  )
end
