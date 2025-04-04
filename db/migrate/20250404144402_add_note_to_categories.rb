class AddNoteToCategories < ActiveRecord::Migration[8.0]
  def change
    add_column :categories, :note, :text
  end
end
