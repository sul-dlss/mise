# frozen_string_literal: true

##
# Workspace class
class Workspace < ApplicationRecord
  belongs_to :project

  def embedded_workspace_state
    state
      &.deep_merge({ 'config' => { 'workspaceControlPanel' => { 'enabled' => false } } })
  end
end
