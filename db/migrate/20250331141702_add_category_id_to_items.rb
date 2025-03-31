class AddCategoryIdToItems < ActiveRecord::Migration[8.0]
  def change
    add_column :items, :category_id, :bigint
  end
end
