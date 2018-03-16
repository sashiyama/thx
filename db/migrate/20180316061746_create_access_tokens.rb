class CreateAccessTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :access_tokens do |t|
      t.references :user, foreign_key: true
      t.string :token, :unique => true
      t.string :refresh_token, :unique => true
      t.datetime :issued_at
      t.datetime :refresh_token_issued_at

      t.timestamps
      t.index :token
      t.index :refresh_token
    end
  end
end
