# frozen_string_literal: true

# :nodoc:
class Ability
  include CanCan::Ability

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def initialize(user, service: false)
    alias_action :embed, to: :read
    alias_action :viewer, to: :read
    alias_action :duplicate, to: :read
    anonymous_abilities

    if service
      can :read, :all
      can :read_historical, :all
    end

    return unless user

    # Short-circuit if user is a site admin, else restrictions below will remove
    # abilities from the admin user
    if user.has_role? :site_admin
      can :manage, :all
      return
    end

    can :create, Project

    project_ids = Project.with_roles(Settings.project_roles, user).pluck(:id)
    can :read, Project, id: project_ids
    can :read, Workspace, project: { id: project_ids }
    can :read, Resource, project: { id: project_ids }
    can :read, Annotot::Annotation, project: { id: project_ids }

    projects = Project.with_roles([:admin] + Settings.project_roles.excluding('viewer'), user)
    project_ids = projects.pluck(:id)
    can %i[read add_to], Project, id: project_ids
    can :manage, Workspace, project: { id: project_ids }
    cannot :feature, Workspace # only site admins can feature workspaces
    can :manage, Resource, project: { id: project_ids }
    can :manage, Annotot::Annotation, project: { id: project_ids }
    can :manage, Role, resource: projects, name: 'viewer'
    can :manage, Role, resource: projects, name: 'editor'

    projects = Project.with_roles(%i[manager], user)
    can :manage, Role, resource: projects, name: 'manager'

    projects = Project.with_roles(%i[admin owner], user)
    project_ids = projects.pluck(:id)
    can :manage, Project, id: project_ids
    can :manage, Role, resource: projects
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def anonymous_abilities
    can :read, Annotot::Annotation, project: { published: true }
    can :read, Project, published: true
    can :read, Workspace, published: true, project: { published: true }
    can :read, Resource, project: { published: true }
  end
end
