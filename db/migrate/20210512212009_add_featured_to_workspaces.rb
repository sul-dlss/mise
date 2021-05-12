class AddFeaturedToWorkspaces < ActiveRecord::Migration[6.1]
  def change
    add_column :workspaces, :featured, :boolean
    add_index :workspaces, :featured
  end
end
