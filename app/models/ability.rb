# frozen_string_literal: true

# :nodoc:
class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    can :manage, :all if user.has_role? :site_admin

    can :create, Resource, resource_type: 'folder', parent_id: nil

    can :manage, Resource, id: Resource.roots.with_role(:admin, user).pluck(:id)
    can :manage, Resource do |resource|
      user.has_role? :admin, resource.root
    end
  end
end
