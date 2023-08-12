class AddActiveStatusToAccount < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :active, :boolean, default: true, null: false
    add_column :accounts, :disabled_at, :datetime
  end
end
