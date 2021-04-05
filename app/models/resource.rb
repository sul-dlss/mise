# frozen_string_literal: true

# Image resources (IIIF or otherwise)
class Resource < ApplicationRecord
  has_ancestry
  resourcify

  belongs_to :project

  has_one_attached :thumbnail
  has_one_attached :file

  before_validation do
    self.project ||= parent&.project
  end
end
