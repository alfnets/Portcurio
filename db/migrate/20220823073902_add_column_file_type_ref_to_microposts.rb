class AddColumnFileTypeRefToMicroposts < ActiveRecord::Migration[6.1]
  def change
    add_reference :microposts, :file_type, after: :file_type, foreign_key: true
  end
end
