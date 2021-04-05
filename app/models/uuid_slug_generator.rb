# frozen_string_literal: true

require 'friendly_id/slug_generator'

# Provide a friendly id slug that's just a uuid
class UuidSlugGenerator < FriendlyId::SlugGenerator
  def generate(*_args)
    10.times do
      uuid = SecureRandom.uuid

      return uuid if available?(uuid)
    end
  end
end
