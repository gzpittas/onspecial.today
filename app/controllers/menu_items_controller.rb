class MenuItemsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  before_action :set_menu_item, only: [:show, :destroy]

  def show
    render json: @menu_item
  end
  
  def create
    @menu_item = MenuItem.new(menu_item_params)
    
    # First find or create the menu_category
    menu = Menu.find(params[:menu_item][:menu_id])
    category = Category.find(params[:menu_item][:menu_category_id])
    
    @menu_item.menu_category = MenuCategory.find_or_create_by!(
      menu: menu,
      category: category
    )

    if @menu_item.save
      render json: { success: true }
    else
      render json: { 
        success: false,
        errors: @menu_item.errors.full_messages
      }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  def update_position
    @menu_item = MenuItem.find(params[:id])
    @menu_item.insert_at(params[:position].to_i)
    head :ok
  end

  def destroy
    @menu_item = MenuItem.find(params[:id])
    @menu_item.destroy
    
    respond_to do |format|
      format.html { redirect_to menu_path(@menu_item.menu), notice: 'Item removed successfully' }
      format.json { head :no_content }
    end
  end

  private

  def set_menu_item
    @menu_item = MenuItem.find(params[:id])
  end

  def menu_item_params
    params.require(:menu_item).permit(:menu_id, :item_id, :menu_category_id)
  end

  def next_available_position(menu_category)
    (menu_category.menu_items.maximum(:position) || 0) + 1
  end
end