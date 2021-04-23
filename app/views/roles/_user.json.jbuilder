# frozen_string_literal: true

json.extract! user, :id, :uid, :email, :provider
json.role user.roles.where(resource: @project).first.name
json.url project_role_path(@project, user)
