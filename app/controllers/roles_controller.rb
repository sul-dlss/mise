# frozen_string_literal: true

# Generic resources controller
class RolesController < ApplicationController
  layout 'project'

  load_and_authorize_resource :project
  before_action only: %i[create update] do
    authorize! :create, @project.roles.build(name: create_params[:role_name])
  end

  # GET /roles or /roles.json
  def index
    @users = @project.users
    respond_to do |format|
      format.json
    end
  end

  # POST /roles or /roles.json
  def create
    user = User.find_or_initialize_by(email: create_params[:email])

    if user.new_record?
      user.update(provider: 'local', uid: create_params[:email])
      user.invite!(current_user)
    elsif user.resource_roles(@project).any?
      head :no_content and return
    end

    user.add_role(create_params[:role_name], @project)
    head :no_content
  end

  def update
    user = User.find_by(id: params[:id])

    user.resource_roles(@project).each do |role|
      authorize! :destroy, role
    end

    user.remove_all_roles(@project)
    user.add_role(role_params[:role_name], @project)

    head :no_content
  end

  # DELETE /roles/1 or /roles/1.json
  def destroy
    user = User.find_by(id: params[:id])

    user.resource_roles(@project).each do |role|
      authorize! :destroy, role
    end

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
