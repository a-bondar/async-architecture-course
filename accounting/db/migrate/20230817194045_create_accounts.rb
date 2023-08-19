class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :public_id
      t.string :full_name
      t.integer :role
      t.string :email
      t.string :position

      t.timestamps
    end
  end
end
