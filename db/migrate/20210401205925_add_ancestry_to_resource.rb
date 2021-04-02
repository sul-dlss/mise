class AddAncestryToResource < ActiveRecord::Migration[6.1]
  def change
    add_column :resources, :ancestry, :string
    add_index :resources, :ancestry
  end
end
