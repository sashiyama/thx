class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :address, null: false
      t.integer :thx_balance
      t.string :status, default: :enable, null: false

      t.timestamps
      t.index :email, unique: true
      t.index :address, unique: true
    end
  end
end
