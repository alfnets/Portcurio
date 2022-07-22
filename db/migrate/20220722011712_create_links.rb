class CreateLinks < ActiveRecord::Migration[6.1]
  def change
    create_table :links do |t|
      t.text :markdown
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
