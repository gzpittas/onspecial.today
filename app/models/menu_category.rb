# app/models/menu_category.rb
class MenuCategory < ApplicationRecord
  belongs_to :menu
  belongs_to :category
  has_many :menu_items, -> { order(position: :asc) }, dependent: :destroy
  
  acts_as_list scope: :menu
end