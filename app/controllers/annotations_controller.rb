# frozen_string_literal: true

# Generic resources controller
class AnnotationsController < Annotot::AnnotationsController
  # Needed because `Annotot::AnnotationsController` does not subclass `ApplicationController`
  include TokenAbility

  prepend_before_action :load_and_authorize_project
  authorize_resource class: 'Annotot::Annotation', except: %i[pages]

  def load_annotations
    @annotations = @project.annotations.where(canvas: annotation_search_params)
  end

  def set_annotation
    @annotation = Annotot::Annotation.where(project: @project).retrieve_by_id_or_uuid(
      CGI.unescape(params[:id])
    )

    raise ActiveRecord::RecordNotFound if @annotation.blank?
  end

  def build_annotation
    @annotation = @project.annotations.build
  end

  private

  def load_and_authorize_project
    return @project if @project

    @project = Project.find(params[:project_id])
    authorize! :read, @project
  end
end
