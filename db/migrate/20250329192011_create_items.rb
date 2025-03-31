class CreateItems < ActiveRecord::Migration[8.0]
  def change
    create_table :items do |t|
      t.string :name
      t.text :description
      t.decimal :credit_price
      t.decimal :cash_price

      t.timestamps
    end
  end
end
