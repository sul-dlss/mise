class CreateResources < ActiveRecord::Migration[6.1]
  def change
    create_table :resources do |t|
      t.string :title
      t.string :mime_type
      t.string :resource_type
      t.string :url

      t.timestamps
    end
  end
end
