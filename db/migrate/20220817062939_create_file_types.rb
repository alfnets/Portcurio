class CreateFileTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :file_types do |t|
      t.string :name
      t.string :value
      t.references :file_category, null: false, foreign_key: true
      t.timestamps
    end
  end
end
