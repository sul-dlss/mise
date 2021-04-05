# frozen_string_literal: true

# Image resources (IIIF or otherwise)
class Resource < ApplicationRecord
  has_ancestry
  resourcify

  include FriendlyId
  friendly_id :slug_candidates, use: %i[finders slugged], slug_generator_class: UuidSlugGenerator

  belongs_to :project

  has_one_attached :thumbnail
  has_one_attached :file

  before_validation do
    self.project ||= parent&.project
  end
end
