# frozen_string_literal: true

# Generic resources controller
class RolesController < ApplicationController
  layout 'project'

  load_and_authorize_resource :project

  # GET /roles or /roles.json
  def index
    @users = User.with_role(:admin, @project)
    respond_to do |format|
      format.json
    end
  end

  # POST /roles or /roles.json
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

  # DELETE /roles/1 or /roles/1.json
  def destroy
    @resource.destroy
    respond_to do |format|
      format.html { redirect_to resources_url, notice: 'Resource was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def role_params
    params.require(:role).permit(:uid, :role_name)
  end
end
