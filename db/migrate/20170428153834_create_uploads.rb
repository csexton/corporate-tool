class CreateUploads < ActiveRecord::Migration[5.0]
  def change
    create_table :uploads do |t|
      t.string :url, null: false
      t.references :user, foreign_key: true
      t.string :file_name
      t.integer :file_size_bytes
      t.string :file_type

      t.timestamps
    end
  end
end
