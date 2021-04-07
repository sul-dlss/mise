# frozen_string_literal: true

# :nodoc:
class Ability
  include CanCan::Ability

  # rubocop:disable Metrics/MethodLength
  def initialize(user, service: false)
    alias_action :embed, to: :read
    anonymous_abilities

    if service
      can :read, :all
      can :read_historical, :all
    end

    return unless user

    can :manage, :all if user.has_role? :site_admin

    can :create, Project

    projects = Project.with_role(:admin, user).pluck(:id)

    can :manage, Project, id: projects
    can :manage, Workspace, project: { id: projects }
    can :manage, Resource, project: { id: projects }
  end
  # rubocop:enable Metrics/MethodLength

  def anonymous_abilities
    can :read, Project, published: true
    can :read, Workspace, published: true, project: { published: true }
    can :read, Resource, project: { published: true }
  end
end
