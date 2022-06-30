class AddLinesToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :linenonce, :string
    add_column :users, :encrypted_lineuid, :string
    add_column :users, :encrypted_lineuid_iv, :string
  end
end
