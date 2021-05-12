# frozen_string_literal: true

# Home page controller
class HomeController < ApplicationController
  skip_authorization_check

  def explore
    @updated_workspaces = Workspace.publicly_accessible.order(updated_at: :desc).limit(5)
    @featured_workspaces = Workspace.publicly_accessible.featured.order(updated_at: :desc).limit(5)
  end

  def dashboard
    @favorites = Workspace.accessible_by(current_ability, :update).favorites.order(updated_at: :desc).limit(3)
    @workspaces = Workspace.accessible_by(current_ability, :update).order(updated_at: :desc).limit(3)
  end
end
