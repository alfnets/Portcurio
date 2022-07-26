class CreateTags < ActiveRecord::Migration[6.1]
  def change
    create_table :tags do |t|
      t.string :name
      t.string :category

      t.timestamps
    end

    add_index :tags, [:name, :category], unique: true
  end
end
