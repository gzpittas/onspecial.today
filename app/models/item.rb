# app/models/item.rb
class Item < ApplicationRecord
  belongs_to :category, optional: true
  has_many :menu_items
  has_many :menus, through: :menu_items
  
  before_save :calculate_prices

  validates :name, presence: true
  
  def calculate_prices
    if credit_price_changed? && !cash_price_changed?
      self.cash_price = credit_price * 0.97
    elsif cash_price_changed? && !credit_price_changed?
      self.credit_price = cash_price / 0.97
    end
  end
end