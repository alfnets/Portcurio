class RemoveFileTypeFromMicroposts < ActiveRecord::Migration[6.1]
  def change
    remove_column :microposts, :file_type, :string
  end
end
