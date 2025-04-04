# app/models/category.rb
class Category < ApplicationRecord
  has_many :menu_categories, dependent: :destroy
  has_many :menus, through: :menu_categories
  has_many :menu_items, through: :menu_categories
  has_many :items, dependent: :nullify

  validates :name, presence: true

  validates :note, length: { maximum: 500 }, allow_blank: true
end