class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.integer :notifier_id
      t.integer :notified_id
      t.references :notificable, polymorphic: true, null: false, intex: true
      t.boolean :checked, default: false, null: false

      t.timestamps
    end
  end
end
