# frozen_string_literal: true

json.extract! resource, :id, :title, :url, :resource_type, :created_at, :updated_at
json.url resource_url(resource, format: :json)
