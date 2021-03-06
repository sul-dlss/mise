# frozen_string_literal: true

json.extract! workspace, :id, :title, :description, :state, :state_type, :created_at, :updated_at
json.url workspace_url(workspace, format: :json)
