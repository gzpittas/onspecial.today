# db/seeds.rb

# Clear existing data in proper order to avoid foreign key violations
MenuItem.destroy_all
MenuCategory.destroy_all
Item.destroy_all
Category.destroy_all
Menu.destroy_all

# Create categories (keeping only the original ones)
categories = [
  { name: "Soup" },
  { name: "Salad" },
  { name: "Sandwich" },
  { name: "Dinner" },
  { name: "Platter" },
  { name: "Dessert" }
]
categories.each { |cat| Category.create!(cat) }

# Create a sample menu
menu = Menu.create!(title: "Daily Specials", date: Date.today)

# Associate all categories with the menu
categories.each do |cat|
  category = Category.find_by(name: cat[:name])
  MenuCategory.create!(
    menu: menu,
    category: category,
    position: category.id
  )
end

# Create items with category assignments
items = [
  # Soups
  { name: "French Onion Soup", description: "Caramelized onions in beef broth with cheese toast", cash_price: 6.99, category: "Soup" },
  { name: "Tomato Basil Soup", description: "Creamy soup with fresh basil", cash_price: 5.99, category: "Soup" },
  { name: "Lobster Bisque", description: "Creamy lobster soup with sherry", cash_price: 9.99, category: "Soup" },
  { name: "Chicken Noodle Soup", description: "Classic comfort soup with egg noodles", cash_price: 5.49, category: "Soup" },
  { name: "Butternut Squash Soup", description: "Velvety smooth with a touch of cream", cash_price: 6.49, category: "Soup" },

  # Salads
  { name: "Caesar Salad", description: "Romaine, croutons, parmesan with Caesar dressing", cash_price: 8.99, category: "Salad" },
  { name: "Cobb Salad", description: "Mixed greens with chicken, bacon, egg, avocado", cash_price: 12.99, category: "Salad" },
  { name: "Greek Salad", description: "Cucumbers, tomatoes, olives, feta with vinaigrette", cash_price: 9.99, category: "Salad" },
  { name: "Asian Chicken Salad", description: "Mixed greens with mandarin oranges and sesame dressing", cash_price: 10.99, category: "Salad" },
  { name: "Caprese Salad", description: "Fresh mozzarella, tomatoes, and basil", cash_price: 8.49, category: "Salad" },

  # Sandwiches
  { name: "Classic Burger", description: "Beef patty with lettuce, tomato and pickles", cash_price: 12.99, category: "Sandwich" },
  { name: "Turkey Club", description: "Triple-decker with bacon and avocado", cash_price: 11.99, category: "Sandwich" },
  { name: "Philly Cheesesteak", description: "Shaved ribeye with peppers and cheese", cash_price: 13.99, category: "Sandwich" },
  { name: "Grilled Chicken Sandwich", description: "Marinated chicken breast with pesto", cash_price: 11.49, category: "Sandwich" },
  { name: "Portobello Mushroom Burger", description: "Marinated portobello with goat cheese", cash_price: 10.99, category: "Sandwich" },

  # Dinner
  { name: "Filet Mignon", description: "8oz tender beef with mashed potatoes", cash_price: 28.99, category: "Dinner" },
  { name: "Grilled Salmon", description: "Atlantic salmon with lemon butter sauce", cash_price: 22.99, category: "Dinner" },
  { name: "Chicken Parmesan", description: "Breaded chicken with marinara and mozzarella", cash_price: 16.99, category: "Dinner" },
  { name: "Beef Short Ribs", description: "Braised ribs with red wine reduction", cash_price: 24.99, category: "Dinner" },
  { name: "Vegetable Risotto", description: "Arborio rice with seasonal vegetables", cash_price: 15.99, category: "Dinner" },

  # Platters
  { name: "Meat Lovers Platter", description: "Assorted cured meats and cheeses", cash_price: 18.99, category: "Platter" },
  { name: "Seafood Tower", description: "Shrimp, oysters, crab legs with sauces", cash_price: 32.99, category: "Platter" },
  { name: "Vegetable Platter", description: "Seasonal roasted vegetables with dips", cash_price: 14.99, category: "Platter" },
  { name: "Cheese Board", description: "Artisanal cheeses with fruit and nuts", cash_price: 16.99, category: "Platter" },
  { name: "Antipasto Platter", description: "Italian cold cuts, cheeses and marinated vegetables", cash_price: 17.99, category: "Platter" },

  # Desserts
  { name: "Chocolate Lava Cake", description: "Warm chocolate cake with molten center", cash_price: 7.99, category: "Dessert" },
  { name: "New York Cheesecake", description: "Classic cheesecake with berry compote", cash_price: 6.99, category: "Dessert" },
  { name: "Crème Brûlée", description: "Vanilla custard with caramelized sugar", cash_price: 7.49, category: "Dessert" },
  { name: "Tiramisu", description: "Coffee-flavored Italian dessert", cash_price: 8.49, category: "Dessert" },
  { name: "Apple Pie", description: "Classic pie with vanilla ice cream", cash_price: 6.49, category: "Dessert" },

  # Additional 15 items
  { name: "Minestrone Soup", description: "Hearty vegetable soup with pasta", cash_price: 6.49, category: "Soup" },
  { name: "Wedge Salad", description: "Iceberg wedge with blue cheese dressing", cash_price: 9.49, category: "Salad" },
  { name: "Reuben Sandwich", description: "Corned beef, sauerkraut, Swiss cheese", cash_price: 12.49, category: "Sandwich" },
  { name: "Chicken Piccata", description: "Lemon butter sauce with capers", cash_price: 18.99, category: "Dinner" },
  { name: "Fruit & Cheese Platter", description: "Seasonal fruits with artisanal cheeses", cash_price: 15.99, category: "Platter" },
  { name: "Bread Pudding", description: "Warm with vanilla sauce", cash_price: 6.99, category: "Dessert" },
  { name: "Clam Chowder", description: "New England style with cream", cash_price: 7.49, category: "Soup" },
  { name: "Spinach Salad", description: "With bacon, mushrooms and warm dressing", cash_price: 10.49, category: "Salad" },
  { name: "BLT Sandwich", description: "Classic bacon, lettuce and tomato", cash_price: 9.99, category: "Sandwich" },
  { name: "Pork Chop", description: "Bone-in with apple compote", cash_price: 19.99, category: "Dinner" },
  { name: "Charcuterie Board", description: "Cured meats, pâtés and accompaniments", cash_price: 22.99, category: "Platter" },
  { name: "Chocolate Mousse", description: "Silky smooth dark chocolate", cash_price: 7.49, category: "Dessert" },
  { name: "Gazpacho", description: "Chilled Spanish tomato soup", cash_price: 5.99, category: "Soup" },
  { name: "Quinoa Salad", description: "With roasted vegetables and feta", cash_price: 11.99, category: "Salad" },
  { name: "Grilled Cheese", description: "Three cheese blend on sourdough", cash_price: 8.99, category: "Sandwich" }
]

# Create items with category assignments and credit prices
items.each do |item_data|
  category = Category.find_by(name: item_data[:category])
  item = Item.new(
    name: item_data[:name],
    description: item_data[:description],
    cash_price: item_data[:cash_price],
    category: category
  )
  item.credit_price = (item.cash_price * 1.03).round(2) # 3% markup for credit
  item.save!
end

# Add 3-5 items to each menu category
Category.all.each do |category|
  menu_category = MenuCategory.find_by(menu: menu, category: category)
  next unless menu_category
  
  category_items = Item.where(category: category).limit(5)
  category_items.each_with_index do |item, index|
    MenuItem.create!(
      menu: menu,
      menu_category: menu_category,
      item: item,
      position: index + 1
    )
  end
end

puts "Seeding completed successfully!"
puts "- #{Category.count} categories"
puts "- #{Item.count} items"
puts "- #{Menu.count} menus"
puts "- #{MenuCategory.count} menu categories"
puts "- #{MenuItem.count} menu items"