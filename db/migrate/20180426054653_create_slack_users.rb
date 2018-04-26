class CreateSlackUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :slack_users do |t|
      t.string :slack_user_id
      t.references :user, foriegn_key: true
      t.string :user_name
      t.string :email

      t.timestamps
    end
  end
end
