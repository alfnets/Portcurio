class AddDeleteDigestToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :delete_digest, :string
  end
end
