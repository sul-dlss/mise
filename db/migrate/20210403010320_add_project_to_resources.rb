class AddProjectToResources < ActiveRecord::Migration[6.1]
  def change
    add_reference :resources, :project, null: false, foreign_key: true
  end
end
