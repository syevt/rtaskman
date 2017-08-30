class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable, :validatable
          # :recoverable, :rememberable, :trackable,
          # :confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User
end
