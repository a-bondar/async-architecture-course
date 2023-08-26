class AddCostToTask < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :cost, :integer, null: false, default: 0
  end
end
