# db/migrate/[timestamp]_add_position_columns.rb
class AddPositionColumns < ActiveRecord::Migration[7.0]
  def change
    unless column_exists?(:menu_categories, :position)
      add_column :menu_categories, :position, :integer
      add_index :menu_categories, [:menu_id, :position]
    end

    unless column_exists?(:menu_items, :position)
      add_column :menu_items, :position, :integer
      add_index :menu_items, [:menu_id, :menu_category_id, :position]
    end
  end
end