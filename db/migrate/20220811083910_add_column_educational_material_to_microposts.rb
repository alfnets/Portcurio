class AddColumnEducationalMaterialToMicroposts < ActiveRecord::Migration[6.1]
  def change
    add_column :microposts, :educational_material, :boolean, default: false, null: false
  end
end
