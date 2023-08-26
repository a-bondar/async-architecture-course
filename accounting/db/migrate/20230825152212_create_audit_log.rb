class CreateAuditLog < ActiveRecord::Migration[7.0]
  def change
    create_table :audit_logs do |t|
      t.integer :balance, null: false, default: 0
      t.integer :transaction
      t.string :description
      t.references :account, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true

      t.timestamps
    end
  end
end
