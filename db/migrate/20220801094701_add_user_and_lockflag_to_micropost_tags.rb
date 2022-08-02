class AddUserAndLockflagToMicropostTags < ActiveRecord::Migration[6.1]
  def change
    add_reference :micropost_tags, :user, foreign_key: true
    add_column    :micropost_tags, :lock_flag, :boolean, default: false, null: false
  end
end
