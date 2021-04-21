# frozen_string_literal: true

json.extract! user, :uid
json.role user.roles.where(resource: @project).first.name
