# frozen_string_literal: true

##
# Workspace class
class Workspace < ApplicationRecord
  belongs_to :project

  include FriendlyId
  friendly_id :slug_candidates, use: %i[finders slugged], slug_generator_class: UuidSlugGenerator

  def embedded_workspace_state
    state
      &.deep_merge({ 'config' => { 'workspaceControlPanel' => { 'enabled' => false } } })
  end

  before_validation do
    self.title ||= 'Untitled workspace'
  end
end
