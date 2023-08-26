class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.string :status
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
