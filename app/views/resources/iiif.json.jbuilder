# frozen_string_literal: true

json.set! :@context, 'http://iiif.io/api/presentation/2/context.json'
json.set! :@id, iiif_project_resources_path(@project)
json.set! :@type, 'sc:Collection'
json.label @project.title
json.viewingHint 'top'
json.description @project.description if @project.description
json.manifests do
end

json.total 0
