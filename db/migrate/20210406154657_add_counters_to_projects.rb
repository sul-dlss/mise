class AddCountersToProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :workspaces_counter, :integer
    add_column :projects, :resources_counter, :integer
  end
end
