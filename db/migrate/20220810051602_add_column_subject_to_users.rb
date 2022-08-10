class AddColumnSubjectToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :school_type, :string
    add_column :users, :subject, :string
  end
end
