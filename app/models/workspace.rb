# frozen_string_literal: true

##
# Workspace class
class Workspace < ApplicationRecord
  acts_as_favoritable

  belongs_to :project, touch: true, counter_cache: true
  has_one_attached :thumbnail
  has_paper_trail

  default_scope -> { order(updated_at: :desc) }
  scope :featured, -> { where(featured: true) }
  scope :publicly_accessible, -> { accessible_by(Ability.new(nil)) }

  include FriendlyId
  friendly_id :slug_candidates, use: %i[finders slugged], slug_generator_class: UuidSlugGenerator

  def embedded_workspace_config
    state
      &.deep_merge({ 'config' => { 'workspaceControlPanel' => { 'enabled' => false } } })
      &.dig('config')
  end

  def catalog_resources
    manifest_ids.map do |manifest_id|
      {
        label: state&.dig('__mise_cache__', 'manifests', manifest_id, 'label'),
        '@type': state&.dig('__mise_cache__', 'manifests', manifest_id, '@type'),
        itemcount: state&.dig('__mise_cache__', 'manifests', manifest_id, 'itemcount'),
        provider: state&.dig('__mise_cache__', 'manifests', manifest_id, 'provider'), # IIIF v3 only
        thumbnail: state&.dig('__mise_cache__', 'manifests', manifest_id, 'thumbnail'),
        '@id': manifest_id
      }
    end
  end

  def manifest_ids
    state&.dig('catalog')&.pluck('manifestId') || []
  end

  before_validation do
    self.title ||= 'Untitled workspace'
  end

  after_save do
    next unless saved_change_to_state?

    ScreenshotWorkspaceJob.perform_later(self, (updated_at + 1.second).iso8601) if Settings.screenshot
  end

  def attributes_for_template
    attributes.slice('state', 'state_type', 'description', 'published').merge('title' => "Duplicate of #{title}")
  end
end
