class AddProjectToAnnototAnnotation < ActiveRecord::Migration[6.1]
  def change
    add_reference :annotot_annotations, :project, null: false, foreign_key: true
  end
end
