# frozen_string_literal: true

# :nodoc:
class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    can :manage, :all if user.has_role? :site_admin

    can :create, Project

    projects = Project.with_role(:admin, user).pluck(:id)

    can :manage, Project, id: projects
    can :manage, Workspace, project: { id: projects }
    can :manage, Resource, project: { id: projects }
  end
end
