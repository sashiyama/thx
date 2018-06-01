class AddSlackInfoToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :slack_user_id, :string, after: :verified
    add_column :users, :slack_team_id, :string, after: :slack_user_id
  end
end
