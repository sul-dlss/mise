# frozen_string_literal: true

# Workspaces controller
class WorkspacesController < ApplicationController
  before_action :set_current_ability_from_token, only: :embed

  load_and_authorize_resource :project
  load_and_authorize_resource through: :project, shallow: true
  before_action :allow_iframe, only: %i[embed]

  def set_current_ability_from_token
    return unless params[:token]

    payload, _header = JWT.decode(params[:token], Rails.application.secret_key_base, true, { algorithm: 'HS256' })
    raise unless payload['workspace'] == params[:id]

    @current_ability = Ability.new(nil, service: true)
  end

  layout 'project'

  # GET /workspaces
  def index
    @workspaces = current_user&.workspaces unless @project
    render layout: 'application' unless @project
  end

  # GET /workspaces/1 or /workspaces/1.json
  def show
    @project = @workspace.project
  end

  # GET /workspaces/1/embed
  def embed
    if params[:timestamp] && (can?(:manage, @workspace) || can?(:read_historical, @workspace))
      @previous_workspace = @workspace.paper_trail.version_at(params[:timestamp])
      @workspace = @previous_workspace if @previous_workspace.present?
    end

    @embed = true

    render template: 'workspaces/viewer', layout: 'embedded'
  end

  # GET /workspaces/1/viewer
  def viewer
    render layout: 'application'
  end

  # POST /workspaces or /workspaces.json
  def create
    respond_to do |format|
      if @workspace.save
        format.html { redirect_to @workspace, notice: create_notice }
        format.json { render :show, status: :created, location: @workspace }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @workspace.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /workspaces/1 or /workspaces/1.json
  def update
    respond_to do |format|
      if @workspace.update(workspace_params)
        format.html { redirect_to @workspace, notice: update_notice }
        format.json { render :show, status: :ok, location: @workspace }
        format.js { render json: {}, status: :ok }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @workspace.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /workspaces/1 or /workspaces/1.json
  def destroy
    @workspace.destroy
    respond_to do |format|
      format.html do
        url = @workspace.project ? project_workspaces_url(@workspace.project) : workspaces_url
        redirect_to url, notice: 'Workspace was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

  def create_notice
    return 'Workspace was successfully created.' unless params[:template] && workspace_project_id.present?

    "The '#{@workspace.title}' workspace was duplicated in '#{Project.find(workspace_project_id).title}.'"
  end

  def update_notice
    return 'Workspace was successfully updated.' if workspace_project_id.blank?

    "The '#{@workspace.title}' workspace was moved to '#{Project.find(workspace_project_id).title}.'"
  end

  def workspace_project_id
    params.dig(:workspace, :project_id)
  end

  # Only allow a list of trusted parameters through.
  def workspace_params
    return {} unless params[:workspace]

    authorize! :update, Project.find(workspace_project_id) if workspace_project_id
    authorize! :feature, @workspace if params.dig(:workspace, :featured)

    params.require(:workspace)
          .permit(:title, :state, :state_type, :project_id, :description, :published, :favorite, :thumbnail, :featured)
          .merge(deserialized_state)
  end

  def create_params
    return workspace_params unless params[:template]

    template = Workspace.find(params[:template])

    authorize! :read, template

    workspace_params.reverse_merge(template.attributes_for_template)
  end

  def deserialized_state
    state = params.require(:workspace)['state']
    return {} if state.blank?

    { state: JSON.parse(state) }
  end

  def allow_iframe
    response.headers.delete('X-Frame-Options')
  end
end
