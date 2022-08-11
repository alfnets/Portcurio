class AddColumnPublishingToMicroposts < ActiveRecord::Migration[6.1]
  def change
    add_column :microposts, :publishing, :string, default: "public", null: false
  end
end
