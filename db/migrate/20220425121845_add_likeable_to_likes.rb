class AddLikeableToLikes < ActiveRecord::Migration[6.1]
  def change
    add_reference :likes, :likeable, polymorphic: true, intex: true, null: false
  end
end
