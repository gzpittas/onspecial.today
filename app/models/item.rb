# app/models/item.rb
class Item < ApplicationRecord
  belongs_to :category
  has_many :menu_items
  has_many :menus, through: :menu_items
  
  before_save :calculate_prices

  before_validation :convert_prices_to_float

  validates :name, presence: true
  validates :category, presence: true
  
  def calculate_prices
    if credit_price_changed? && !cash_price_changed?
      self.cash_price = credit_price * 0.97
    elsif cash_price_changed? && !credit_price_changed?
      self.credit_price = cash_price / 0.97
    end
  end

  # app/models/menu.rb
  def title_with_date
    "#{title} (#{date.strftime('%b %d, %Y')})"
  end

  def category_id
    category&.id
  end

  def convert_prices_to_float
    self.cash_price = cash_price.to_f if cash_price.present?
    self.credit_price = credit_price.to_f if credit_price.present?
  end


end





