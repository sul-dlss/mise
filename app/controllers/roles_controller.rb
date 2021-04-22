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
    authorize! :manage, @project
    user = User.find_or_initialize_by(email: role_params[:uid])
    if user.new_record?
      user.update(provider: 'invited', uid: role_params[:uid])
      user.invite!(current_user)
    end

    user.remove_all_roles(@project)
    user.add_role(role_params[:role_name], @project)
    head :no_content
  end

  # DELETE /roles/1 or /roles/1.json
  def destroy
    # auth check
    authorize! :manage, @project
    user = User.find_by(provider: role_params[:provider], uid: role_params[:uid])
    user.remove_all_roles(@project)
    head :no_content
  end

  private

  # Only allow a list of trusted parameters through.
  def role_params
    params.require(:role).permit(:uid, :role_name, :provider)
  end
end
