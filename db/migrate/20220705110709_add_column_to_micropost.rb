class AddColumnToMicropost < ActiveRecord::Migration[6.1]
  def change
    add_column :microposts, :file_type, :string
    add_column :microposts, :file_link, :text
  end
end
