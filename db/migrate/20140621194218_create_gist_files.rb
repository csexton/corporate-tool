class CreateGistFiles < ActiveRecord::Migration[4.1]
  def change
    create_table :gist_files do |t|
      t.string :file_type
      t.string :file_name
      t.text :body
      t.references :gist, index: true

      t.timestamps
    end
  end
end
