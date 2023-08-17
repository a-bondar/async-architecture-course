class AddPositionToAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :position, :string
  end
end
