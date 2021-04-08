# frozen_string_literal: true

# Generic resources controller
class ResourcesController < ApplicationController
  layout 'project'

  load_and_authorize_resource :project
  load_and_authorize_resource through: :project, shallow: true

  # GET /resources or /resources.json
  def index; end

  # GET /resources/1 or /resources/1.json
  def show; end

  # GET /resources/new
  def new; end

  # GET /resources/1/edit
  def edit; end

  def iiif
    respond_to do |format|
      format.json
    end
  end

  # POST /resources or /resources.json
  def create
    respond_to do |format|
      if @resource.save
        format.html { redirect_to @resource, notice: 'Resource was successfully created.' }
        format.json { render :show, status: :created, location: @resource }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /resources/1 or /resources/1.json
  def update
    respond_to do |format|
      if @resource.update(resource_params)
        format.html { redirect_to @resource, notice: 'Resource was successfully updated.' }
        format.json { render :show, status: :ok, location: @resource }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /resources/1 or /resources/1.json
  def destroy
    @resource.destroy
    respond_to do |format|
      format.html { redirect_to resources_url, notice: 'Resource was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def resource_params
    params.require(:resource).permit(:title, :url, :resource_type, :project_id)
  end
end
