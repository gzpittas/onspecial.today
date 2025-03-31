class RemovePositionFromMenuCategories < ActiveRecord::Migration[8.0]
  def change
    remove_column :menu_categories, :position, :integer
  end
end
