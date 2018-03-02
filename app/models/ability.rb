class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    can(:create, [Project, Task])
    can([:read, :update, :destroy], Project, user_id: user.id)
    can([:update, :destroy], Task, project: { user_id: user.id })
  end
end
