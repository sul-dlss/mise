# frozen_string_literal: true

# Generic resources controller
class AnnotationsController < Annotot::AnnotationsController
  before_action :load_and_authorize_project
  authorize_resource class: 'Annotot::Annotation', except: %i[pages]

  def load_and_authorize_project
    return @project if @project

    @project = Project.find(params[:project_id])
    authorize! :read, @project
  end

  def load_annotations
    load_and_authorize_project
    @annotations = @project.annotations.where(canvas: annotation_search_params)
  end

  def set_annotation
    load_and_authorize_project
    @annotation = Annotot::Annotation.where(project: @project).retrieve_by_id_or_uuid(
      CGI.unescape(params[:id])
    )

    raise ActiveRecord::RecordNotFound if @annotation.blank?
  end

  def build_annotation
    load_and_authorize_project
    @annotation = @project.annotations.build
  end
end
