# frozen_string_literal: true

# :nodoc:
module ApplicationHelper
  ##
  # Creates a IIIF Drag 'n Drop link with IIIF logo
  # @param [String] manifest URL
  # @param [String, Number] width
  # @param [String] position
  def iiif_drag_n_drop(manifest, width: '40', position: 'left')
    link_to(
      manifest,
      class: 'iiif-dnd pull-right',
      data: { turbolinks: false, toggle: 'tooltip', placement: position, manifest: manifest },
      title: 'Drag icon to any IIIF viewer. — Click icon to learn more.'
    ) do
      image_tag 'iiif-drag-n-drop.svg', width: width, alt: 'IIIF Drag-n-drop'
    end
  end

  def url_for_project_resource(project, resource)
    return resource[:@id] if /\A#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}\z/.match?(resource[:@id])

    project_resource_path(project, resource[:@id])
  end
end
