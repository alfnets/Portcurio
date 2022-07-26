class CreateMicropostTags < ActiveRecord::Migration[6.1]
  def change
    create_table :micropost_tags do |t|
      t.references :micropost, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
