class CreateMenuItems < ActiveRecord::Migration[8.0]
  def change
    create_table :menu_items do |t|
      t.references :menu, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true
      t.references :menu_category, null: false, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
