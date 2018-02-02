class Project < ApplicationRecord
  belongs_to :user
  has_many :tasks

  validates :name,
            presence: true,
            format: { with: /\A[\p{Alnum}.\s]+\z/ }
end
