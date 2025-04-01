class MenuItem < ApplicationRecord
  belongs_to :menu
  belongs_to :item
  belongs_to :menu_category
  
  acts_as_list scope: [:menu, :menu_category]
  
  validates :menu_id, :item_id, presence: true
  # Remove the menu_category_id validation since we handle it in controller
end