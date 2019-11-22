class DropGists < ActiveRecord::Migration[6.0]
  def change
    drop_table :gists
    drop_table :gist_files
  end
end
