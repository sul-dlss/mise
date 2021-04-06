class RenameCountersOnProjects < ActiveRecord::Migration[6.1]
  def change
    rename_column :projects, :workspaces_counter, :workspaces_count
    rename_column :projects, :resources_counter, :resources_count
  end
end
