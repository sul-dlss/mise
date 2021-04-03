# frozen_string_literal: true

# Projects group together workspaces and resources
class Project < ApplicationRecord
  has_many :workspaces, dependent: :destroy
  has_many :resources, dependent: :destroy
  resourcify
end
