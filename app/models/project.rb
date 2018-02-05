class Project < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy

  validates :name,
            presence: true,
            format: { with: /\A[\p{Alnum}.\s]+\z/ }
end
