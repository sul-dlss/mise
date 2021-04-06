class AddFieldsToWorkspaces < ActiveRecord::Migration[6.1]
  def change
    add_column :workspaces, :description, :text
    add_column :workspaces, :published, :boolean
  end
end
