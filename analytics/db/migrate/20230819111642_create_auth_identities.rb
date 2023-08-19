class CreateAuthIdentities < ActiveRecord::Migration[7.0]
  def change
    create_table :auth_identities do |t|
      t.string :provider
      t.string :login
      t.string :token
      t.string :uid
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
