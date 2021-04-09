# frozen_string_literal: true

# Home page controller
class HomeController < ApplicationController
  skip_authorization_check

  def show
    @workspaces = Workspace.accessible_by(Ability.new(nil)).order(updated_at: :desc).limit(5)
  end
end
