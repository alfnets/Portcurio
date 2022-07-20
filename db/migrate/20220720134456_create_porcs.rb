class CreatePorcs < ActiveRecord::Migration[6.1]
  def change
    create_table :porcs do |t|
      t.references :user, foreign_key: true
      t.references :micropost, foreign_key: true
      t.timestamps
    end
  end
end
