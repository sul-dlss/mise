# frozen_string_literal: true

# Generic resources controller
class RolesController < ApplicationController
  layout 'project'

  load_and_authorize_resource :project

  # GET /roles or /roles.json
  def index
    @users = @project.users
    respond_to do |format|
      format.json
    end
  end

  # POST /roles or /roles.json
  def create
    authorize! :manage, @project
    user = User.find_or_initialize_by(email: create_params[:email])
    if user.new_record?
      user.update(provider: 'local', uid: create_params[:email])
      user.invite!(current_user)
    end

    user.remove_all_roles(@project)
    user.add_role(create_params[:role_name], @project)
    head :no_content
  end

  def update
    authorize! :manage, @project
    user = User.find_by(id: params[:id])
    user.remove_all_roles(@project)
    user.add_role(role_params[:role_name], @project)
    head :no_content
  end

  # DELETE /roles/1 or /roles/1.json
  def destroy
    authorize! :manage, @project
    user = User.find_by(id: params[:id])
    user.remove_all_roles(@project)
    head :no_content
  end

  private

  def create_params
    params.require(:role).permit(:email, :role_name)
  end

  # Only allow a list of trusted parameters through.
  def role_params
    params.require(:role).permit(:id, :uid, :role_name, :provider)
  end
end
