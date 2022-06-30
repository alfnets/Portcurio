class AddLinksToMicroposts < ActiveRecord::Migration[6.1]
  def change
    add_column :microposts, :links, :text
  end
end
