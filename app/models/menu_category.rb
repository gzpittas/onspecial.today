# app/models/menu_category.rb
class MenuCategory < ApplicationRecord
  belongs_to :menu
  belongs_to :category
  has_many :menu_items, -> { order(position: :asc) }
  
  acts_as_list scope: :menu
end