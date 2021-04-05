# frozen_string_literal: true

# :nodoc:
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def slug_candidates
    []
  end
end
