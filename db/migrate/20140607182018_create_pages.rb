class CreatePages < ActiveRecord::Migration[4.1]
  def change
    create_table :pages do |t|
      t.string :title
      t.string :comment
      t.string :path
      t.text :body

      t.timestamps
    end
  end
end
