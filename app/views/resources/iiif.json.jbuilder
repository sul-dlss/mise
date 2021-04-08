# frozen_string_literal: true

json.set! :@context, 'http://iiif.io/api/presentation/2/context.json'
json.set! :@id, iiif_project_resources_url(@project)
json.set! :@type, 'sc:Collection'
json.label @project.title
json.viewingHint 'top'
json.description @project.description if @project.description

resources = @project.iiif_collection_resources(except: [iiif_project_resources_url(@project)])

json.manifests do
  json.array!(resources) do |(id, entry)|
    json.set! :@id, id
    json.set! :@type, entry[:@type]
    json.label entry[:label]
  end
end

json.total resources.count
