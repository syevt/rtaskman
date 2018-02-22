class Task < ApplicationRecord
  belongs_to :project

  validates :content,
            presence: true,
            format: { with: /\A[\p{Alnum}.,\-()"'`?\s]+\z/ }
end
