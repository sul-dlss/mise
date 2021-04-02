# frozen_string_literal: true

class Resource < ApplicationRecord
  has_ancestry
  resourcify

  has_one_attached :thumbnail
  has_one_attached :file

  scope :folders, -> { where(resource_type: 'folder') }
end
