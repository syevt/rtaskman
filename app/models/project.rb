class Project < ApplicationRecord
  belongs_to :user

  validates :name,
            presence: true,
            format: { with: /\A[\p{Alnum}\s]+\z/ }
end
