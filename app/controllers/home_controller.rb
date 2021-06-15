# frozen_string_literal: true

# Home page controller
class HomeController < ApplicationController
  skip_authorization_check

  def public
    @featured_workspaces = Workspace.publicly_accessible.featured.limit(3)
  end

  def explore
    @updated_workspaces = Workspace.publicly_accessible.limit(5)
    @featured_workspaces = Workspace.publicly_accessible.featured.limit(5)
  end

  def dashboard
    @favorites = current_user.favorited_workspaces.accessible_by(current_ability, :favorite).limit(3)
    @workspaces = Workspace.accessible_by(current_ability, :update).limit(3)
  end
end
