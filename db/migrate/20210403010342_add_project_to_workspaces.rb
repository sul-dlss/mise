class AddProjectToWorkspaces < ActiveRecord::Migration[6.1]
  def change
    add_reference :workspaces, :project, null: false, foreign_key: true
  end
end
