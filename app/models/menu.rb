# app/models/menu.rb
class Menu < ApplicationRecord
  has_many :menu_categories, -> { order(position: :asc) }, dependent: :destroy
  has_many :categories, through: :menu_categories
  has_many :menu_items, through: :menu_categories
  has_many :items, through: :menu_items
end