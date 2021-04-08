# frozen_string_literal: true

json.set! :@context, 'http://iiif.io/api/presentation/2/context.json'
json.set! :@id, iiif_project_resources_path(@project)
json.set! :@type, 'sc:Collection'
json.label @project.title
json.viewingHint 'top'
json.description @project.description if @project.description
json.manifests do
  json.array!(@project.workspaces.find_each.with_object(Set.new) { |w, memo| memo.merge w.state&.dig('catalog')&.pluck('manifestId') }) do |entry|
    json.set! :@id, entry
    json.set! :@type, 'sc:manifest'
    json.label entry
  end
end

json.total 0
