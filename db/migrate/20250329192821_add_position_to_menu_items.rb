# Look for the migration file in db/migrate/[timestamp]_add_position_to_menu_items.rb
# Modify it to look like this:

class AddPositionToMenuItems < ActiveRecord::Migration[7.0]
  def change
    unless column_exists?(:menu_items, :position)
      add_column :menu_items, :position, :integer
    end
  end
end