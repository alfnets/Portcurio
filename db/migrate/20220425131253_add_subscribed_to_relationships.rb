class AddSubscribedToRelationships < ActiveRecord::Migration[6.1]
  def change
    add_column :relationships, :subscribed, :boolean, default: false, null: false    
  end
end
