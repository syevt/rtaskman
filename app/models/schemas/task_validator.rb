require 'json-schema'

module TaskValidator
  task_content_format = lambda { |value|
    unless value =~ /\A[\p{Alnum}.\s]+\z/
      raise JSON::Schema::CustomFormatError.new('has invalid format')
    end
  }

  JSON::Validator.register_format_validator(
    'task-content-format', task_content_format
  )

  TASKS_SCHEMA = {
    type: 'array',
    items: {
      type: 'object',
      required: ['done', 'content', 'deadline'],
      properties: {
        done: { type: 'boolean' },
        content: {
          type: 'string',
          format: 'task-content-format'
        },
        deadline: {
          type: 'string',
          format: 'date'
        }
      }
    }
  }.freeze
end
