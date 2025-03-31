# app/models/menu_item.rb
class MenuItem < ApplicationRecord
  belongs_to :menu
  belongs_to :item
  belongs_to :menu_category
  
  acts_as_list scope: [:menu, :menu_category]
end