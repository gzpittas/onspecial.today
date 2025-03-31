# db/seeds.rb

# Clear existing data in proper order to avoid foreign key violations
MenuItem.destroy_all
MenuCategory.destroy_all
Item.destroy_all
Category.destroy_all
Menu.destroy_all

# Create categories
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

# Associate all categories with the menu and store menu_categories
menu_categories = []
categories.each do |cat|
  category = Category.find_by(name: cat[:name])
  menu_categories << MenuCategory.create!(
    menu: menu,
    category: category,
    position: category.id
  )
end

# Create items with realistic data
items = [
  # Appetizers
  { name: "Mozzarella Sticks", description: "Crispy breaded mozzarella with marinara", cash_price: 7.99 },
  { name: "Spinach Artichoke Dip", description: "Creamy dip with tortilla chips", cash_price: 8.49 },
  { name: "Buffalo Wings", description: "Crispy chicken wings with choice of sauce", cash_price: 10.99 },
  { name: "Bruschetta", description: "Toasted bread with tomatoes, garlic and basil", cash_price: 7.49 },
  { name: "Calamari", description: "Fried squid with lemon aioli", cash_price: 11.99 },

  # Soups & Salads
  { name: "French Onion Soup", description: "Caramelized onions in beef broth with cheese toast", cash_price: 6.99 },
  { name: "Caesar Salad", description: "Romaine, croutons, parmesan with Caesar dressing", cash_price: 8.99 },
  { name: "Tomato Basil Soup", description: "Creamy soup with fresh basil", cash_price: 5.99 },
  { name: "Cobb Salad", description: "Mixed greens with chicken, bacon, egg, avocado", cash_price: 12.99 },
  { name: "Lobster Bisque", description: "Creamy lobster soup with sherry", cash_price: 9.99 },

  # Main Courses
  { name: "Filet Mignon", description: "8oz tender beef with mashed potatoes", cash_price: 28.99 },
  { name: "Grilled Salmon", description: "Atlantic salmon with lemon butter sauce", cash_price: 22.99 },
  { name: "Chicken Parmesan", description: "Breaded chicken with marinara and mozzarella", cash_price: 16.99 },
  { name: "Beef Short Ribs", description: "Braised ribs with red wine reduction", cash_price: 24.99 },
  { name: "Vegetable Risotto", description: "Arborio rice with seasonal vegetables", cash_price: 15.99 },

  # Sandwiches
  { name: "Classic Burger", description: "Beef patty with lettuce, tomato and pickles", cash_price: 12.99 },
  { name: "Turkey Club", description: "Triple-decker with bacon and avocado", cash_price: 11.99 },
  { name: "Philly Cheesesteak", description: "Shaved ribeye with peppers and cheese", cash_price: 13.99 },
  { name: "Grilled Chicken Sandwich", description: "Marinated chicken breast with pesto", cash_price: 11.49 },
  { name: "Portobello Mushroom Burger", description: "Marinated portobello with goat cheese", cash_price: 10.99 },

  # Desserts
  { name: "Chocolate Lava Cake", description: "Warm chocolate cake with molten center", cash_price: 7.99 },
  { name: "New York Cheesecake", description: "Classic cheesecake with berry compote", cash_price: 6.99 },
  { name: "Crème Brûlée", description: "Vanilla custard with caramelized sugar", cash_price: 7.49 },
  { name: "Tiramisu", description: "Coffee-flavored Italian dessert", cash_price: 8.49 },
  { name: "Apple Pie", description: "Classic pie with vanilla ice cream", cash_price: 6.49 },

  # Beverages
  { name: "Fresh Lemonade", description: "House-made with fresh lemons", cash_price: 3.99 },
  { name: "Iced Tea", description: "Fresh brewed with lemon", cash_price: 2.99 },
  { name: "Craft Beer", description: "Selection of local brews", cash_price: 6.99 },
  { name: "House Red Wine", description: "Cabernet Sauvignon", cash_price: 8.99 },
  { name: "Espresso", description: "Single or double shot", cash_price: 2.49 }
]

# Create items and calculate credit prices (3% markup)
items.each do |item_data|
  item = Item.new(item_data)
  item.credit_price = (item.cash_price * 1.03).round(2) # 3% markup for credit
  item.save!
end

# Add items to menu categories
appetizer_category = Category.find_by(name: "Appetizer")
main_courses_category = Category.find_by(name: "Dinner") # Changed from "Main Courses" to match your categories
desserts_category = Category.find_by(name: "Desserts")

menu_category_app = MenuCategory.find_by(menu: menu, category: appetizer_category)
menu_category_main = MenuCategory.find_by(menu: menu, category: main_courses_category)
menu_category_dessert = MenuCategory.find_by(menu: menu, category: desserts_category)

# Add items to menu categories
[menu_category_app, menu_category_main, menu_category_dessert].each do |menu_category|
  next unless menu_category # Skip if menu_category doesn't exist
  
  category_items = Item.where(category: menu_category.category).limit(3)
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
