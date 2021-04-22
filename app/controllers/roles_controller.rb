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
    # auth check that user can manage roles AND they are allowed to assign that role (e.g. no one besides owner can add owners?)
    # try to get a user object
    user = User.find_or_initialize_by(email: role_params[:uid])
    if user.new_record?
      user.update(provider: 'invited', uid: role_params[:uid])
      user.invite!(current_user)
    end

    user.roles.where(resource: @project).delete_all
    user.add_role(role_params[:role_name], @project)
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
