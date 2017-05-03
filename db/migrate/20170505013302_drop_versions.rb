class DropVersions < ActiveRecord::Migration[5.0]
  def change
    drop_table :versions
  end
end
