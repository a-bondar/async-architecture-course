class AddRoleToAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :role, :integer, default: 0, null: false
  end
end
