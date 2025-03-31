# app/controllers/menus_controller.rb
class MenusController < ApplicationController
  before_action :set_menu, only: [:show, :edit, :update, :destroy, :add_category, :add_item]

  def index
    @menus = Menu.order(date: :desc)
  end

  def show
    @menu_categories = @menu.menu_categories.includes(:category, menu_items: :item)
  end

  def new
    @menu = Menu.new(date: Date.today)
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
    menu_category = @menu.menu_categories.find(params[:menu_category_id])
    item = Item.find(params[:item_id])
    menu_category.menu_items.create(item: item)
    redirect_to @menu, notice: 'Item added to menu'
  end

  private
    def set_menu
      @menu = Menu.find(params[:id])
    end

    def menu_params
      params.require(:menu).permit(:title, :date)
    end
end