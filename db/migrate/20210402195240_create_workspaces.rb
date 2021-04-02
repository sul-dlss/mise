class CreateWorkspaces < ActiveRecord::Migration[6.1]
  def change
    create_table :workspaces do |t|
      t.json :state
      t.string :state_type
      t.references :resource, null: false, foreign_key: true

      t.timestamps
    end
  end
end
