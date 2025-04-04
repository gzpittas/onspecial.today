# db/migrate/[timestamp]_add_unique_index_to_items_name.rb
class AddUniqueIndexToItemsName < ActiveRecord::Migration[8.0]
  def change
    add_index :items, :name, unique: true
  end
end