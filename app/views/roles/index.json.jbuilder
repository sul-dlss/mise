# frozen_string_literal: true

json.users do
  json.array! @users, partial: 'roles/user', as: :user
end
json.assignableRoles(Settings.project_roles.select { |role| can? :manage, @project.roles.build(name: role) })
