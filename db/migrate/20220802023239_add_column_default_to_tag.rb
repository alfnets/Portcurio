class AddColumnDefaultToTag < ActiveRecord::Migration[6.1]
  def change
    add_column :tags, :default_flag, :boolean, default: false, null: false
  end
end
