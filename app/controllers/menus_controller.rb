# app/controllers/menus_controller.rb
class MenusController < ApplicationController
  before_action :set_menu, only: [:show, :edit, :update, :destroy, :add_category, :add_item, :print]

  def index
    @menus = Menu.order(date: :asc)
  end

  def show
    @menu = Menu.find(params[:id])
    @menu_categories = @menu.menu_categories.includes(:category, menu_items: :item)
    @items = Item.all.order(:name) # This ensures @items is never nil
  end

  def new
    @menu = Menu.new(title: "TODAY'S SPECIALS", date: Date.today)
  end

  def edit
  end

  def create
    @menu = Menu.new(menu_params)

    if @menu.save
      redirect_to @menu, notice: 'Menu was successfully created.'
    else
      render :new
    end
  end

  def update
    if @menu.update(menu_params)
      redirect_to @menu, notice: 'Menu was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @menu.destroy
    redirect_to menus_url, notice: 'Menu was successfully destroyed.'
  end

  def add_category
    category = Category.find(params[:category_id])
    @menu.menu_categories.create(category: category)
    redirect_to @menu, notice: 'Category added to menu'
  end

  def add_item
    @menu = Menu.find(params[:id])
    item = Item.find(params[:item_id])
    
    # Find or create menu category based on item's category
    menu_category = @menu.menu_categories.find_or_create_by(category: item.category || Category.first)
    
    # Create the menu item
    menu_item = menu_category.menu_items.create(
      menu: @menu,
      item: item,
      position: menu_category.menu_items.maximum(:position).to_i + 1
    )
    
    if menu_item.persisted?
      redirect_to @menu, notice: 'Item added to menu successfully'
    else
      redirect_to @menu, alert: "Failed to add item: #{menu_item.errors.full_messages.join(', ')}"
    end
  rescue ActiveRecord::RecordNotFound => e
    redirect_to @menu, alert: "Error: #{e.message}"
  end

  def clear
    @menu = Menu.find(params[:id])
    
    # Either destroy through the join table:
    MenuItem.where(menu_id: @menu.id).destroy_all
    
    # OR alternative approach:
    # @menu.menu_categories.each { |mc| mc.menu_items.destroy_all }
    
    redirect_to @menu, notice: 'All items have been removed from the menu.'
  end

  # app/controllers/menus_controller.rb
  def print
    @menu_categories = @menu.menu_categories.includes(:category, menu_items: :item)
    render layout: false
  end

  private
  
    def set_menu
      @menu = Menu.find(params[:id])
    end

    def menu_params
      params.require(:menu).permit(:title, :date)
    end
end