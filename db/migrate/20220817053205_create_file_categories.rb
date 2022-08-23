class CreateFileCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :file_categories do |t|
      t.string :name
      t.timestamps
    end
  end
end
