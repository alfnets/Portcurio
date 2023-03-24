class AddPrivateToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :private, :boolean, null: false, default: false, after: :email
  end
end
