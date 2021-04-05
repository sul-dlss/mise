class AddSlugToResources < ActiveRecord::Migration[6.1]
  def change
    add_column :resources, :slug, :string
    add_index :resources, :slug, unique: true

    add_column :workspaces, :slug, :string
    add_index :workspaces, :slug, unique: true

    add_column :projects, :slug, :string
    add_index :projects, :slug, unique: true
  end
end
