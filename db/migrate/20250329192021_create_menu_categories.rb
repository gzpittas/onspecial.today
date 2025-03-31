class CreateMenuCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :menu_categories do |t|
      t.references :menu, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
