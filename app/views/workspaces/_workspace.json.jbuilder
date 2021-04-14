# frozen_string_literal: true

json.extract! workspace, :id, :title, :state, :state_type, :created_at, :updated_at, :favorite
json.url workspace_url(workspace, format: :json)
