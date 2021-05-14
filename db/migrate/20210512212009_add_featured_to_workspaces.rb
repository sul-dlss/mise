class AddFeaturedToWorkspaces < ActiveRecord::Migration[6.1]
  def change
    add_column :workspaces, :featured, :boolean, default: false
    add_index :workspaces, :featured
  end
end
