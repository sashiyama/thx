class AddDetailsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :name, :string, after: :password_digest
    add_column :users, :verified, :boolean, default: false, after: :status
  end
end
