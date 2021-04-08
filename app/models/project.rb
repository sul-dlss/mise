# frozen_string_literal: true

# Projects group together workspaces and resources
class Project < ApplicationRecord
  has_paper_trail

  has_many :workspaces, dependent: :destroy
  has_many :resources, dependent: :destroy
  resourcify

  include FriendlyId
  friendly_id :slug_candidates, use: %i[finders slugged], slug_generator_class: UuidSlugGenerator

  before_validation do
    self.title ||= 'Untitled project'
  end

  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def iiif_collection_resources(except: [])
    workspaces.find_each.with_object({}) do |workspace, hash|
      workspace.state&.dig('catalog')&.pluck('manifestId')&.each do |manifest_id|
        next if hash.dig(manifest_id, :label) || except.include?(manifest_id)

        hash[manifest_id] = {
          label: workspace.state&.dig('__mise_cache__', 'manifests', manifest_id, 'label'),
          '@type': workspace.state&.dig('__mise_cache__', 'manifests', manifest_id, '@type')
        }
      end
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
end
