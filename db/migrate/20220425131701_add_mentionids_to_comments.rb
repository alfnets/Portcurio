class AddMentionidsToComments < ActiveRecord::Migration[6.1]
  def change
    add_column :comments, :mention_ids, :string
  end
end
