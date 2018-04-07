class Task < ApplicationRecord
  belongs_to :project

  validates :content,
            presence: true,
            format: { with: /\A[\p{Alnum}.,\-\/()"'`?!\s]+\z/ }

  validates_numericality_of :priority,
                            only_integer: true,
                            greater_than_or_equal_to: 0
end
