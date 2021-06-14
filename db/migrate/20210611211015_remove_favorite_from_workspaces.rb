class RemoveFavoriteFromWorkspaces < ActiveRecord::Migration[6.1]
  def change
    remove_column :workspaces, :favorite, :boolean
  end
end
