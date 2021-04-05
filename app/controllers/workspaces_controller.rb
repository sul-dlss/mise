# frozen_string_literal: true

# Workspaces controller
class WorkspacesController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource through: :project, shallow: true
  before_action :allow_iframe, only: %i[embed]

  # GET /workspaces
  def index
    render layout: 'project'
  end

  # GET /workspaces/1 or /workspaces/1.json
  def show; end

  # GET /workspaces/1/embed
  def embed
    render layout: 'embedded'
  end

  # GET /workspaces/new
  def new; end

  # GET /workspaces/1/edit
  def edit; end

  # POST /workspaces or /workspaces.json
  def create
    respond_to do |format|
      if @workspace.save
        format.html { redirect_to @workspace, notice: 'Workspace was successfully created.' }
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
        format.html { redirect_to @workspace, notice: 'Workspace was successfully updated.' }
        format.json { render :show, status: :ok, location: @workspace }
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
      format.html { redirect_to workspaces_url, notice: 'Workspace was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def workspace_params
    params.require(:workspace).permit(:title, :state, :state_type, :project_id).merge({ state: deserialized_state })
  end

  def deserialized_state
    state = params.require(:workspace)['state']
    return nil if state.blank?

    JSON.parse(state)
  end

  def allow_iframe
    response.headers.delete('X-Frame-Options')
  end
end
