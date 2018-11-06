class Project < ApplicationRecord
  belongs_to :user
  has_many :tasks, -> { order(:priority) }, dependent: :destroy, autosave: true

  validates :name,
            presence: true,
            format: { with: /\A[\p{Alnum}.,\-\/()"'`?!\s]+\z/ }
end
