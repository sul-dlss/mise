# frozen_string_literal: true

# Generic resources controller
class ResourcesController < ApplicationController
  load_and_authorize_resource except: [:index]
  skip_authorization_check only: [:index]

  # GET /resources or /resources.json
  def index
    @resources = Resource.roots.with_role(:admin, current_user).distinct
  end

  # GET /resources/1 or /resources/1.json
  def show; end

  # GET /resources/new
  def new
    @resource.parent_id = params[:id]
  end

  # GET /resources/1/edit
  def edit; end

  # POST /resources or /resources.json
  def create
    respond_to do |format|
      if @resource.save
        current_user.add_role(:admin, @resource)

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
    params.require(:resource).permit(:title, :url, :resource_type, :parent_id)
  end
end
