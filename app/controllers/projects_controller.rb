# frozen_string_literal: true

# Top-level projects
class ProjectsController < ApplicationController
  load_and_authorize_resource
  layout 'project'

  # GET /projects or /projects.json
  def index
    render layout: 'application'
  end

  # GET /projects/1 or /projects/1.json
  def show; end

  # GET /projects/new
  def new; end

  # GET /projects/1/edit
  def edit; end

  # POST /projects or /projects.json
  def create
    respond_to do |format|
      if @project.save
        current_user.add_role(:admin, @project)

        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1 or /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1 or /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def project_params
    params.require(:project).permit(:title)
  end
end
