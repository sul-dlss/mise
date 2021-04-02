# frozen_string_literal: true

json.extract! workspace, :id, :state, :state_type, :resource_id, :created_at, :updated_at
json.url workspace_url(workspace, format: :json)
