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
end
