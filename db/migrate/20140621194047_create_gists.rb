class CreateGists < ActiveRecord::Migration[4.2]
  def change
    create_table :gists do |t|
      t.string :description
      t.references :user, index: true

      t.timestamps
    end
  end
end
