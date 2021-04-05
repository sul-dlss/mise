class RemoveResourceFromWorkspaces < ActiveRecord::Migration[6.1]
  def change
    remove_column :workspaces, :resource_id
  end
end
