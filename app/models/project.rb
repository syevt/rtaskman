class Project < ApplicationRecord
  belongs_to :user
  has_many :tasks

  validates :name,
            presence: true,
            format: { with: /\A[\p{Alnum}.\s]+\z/ }

  task_content_format = lambda { |value|
    unless value =~ /\A[\p{Alnum}.\s]+\z/
      raise JSON::Schema::CustomFormatError.new('has invalid format')
    end
  }
end
