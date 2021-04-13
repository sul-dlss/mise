# frozen_string_literal: true

# Home page controller
class HomeController < ApplicationController
  skip_authorization_check

  def show
    @workspaces = Workspace.accessible_by(Ability.new(nil)).order(updated_at: :desc).limit(5)
  end

  def dashboard
    @favorites = Workspace.accessible_by(current_ability, :update).favorites.order(updated_at: :desc).limit(3)
    @workspaces = Workspace.accessible_by(current_ability, :update).order(updated_at: :desc).limit(3)
  end
end
