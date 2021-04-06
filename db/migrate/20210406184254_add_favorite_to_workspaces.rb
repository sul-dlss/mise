class AddFavoriteToWorkspaces < ActiveRecord::Migration[6.1]
  def change
    add_column :workspaces, :favorite, :boolean, default: false
  end
end
