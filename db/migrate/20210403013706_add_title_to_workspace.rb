class AddTitleToWorkspace < ActiveRecord::Migration[6.1]
  def change
    add_column :workspaces, :title, :string
  end
end
