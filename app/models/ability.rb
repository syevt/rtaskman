class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    can(:create, Project)
    can([:read, :update, :destroy], Project, user_id: user.id)
  end
end
