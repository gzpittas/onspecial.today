class ItemsController < ApplicationController
  before_action :set_item, only: %i[ show edit update destroy ]

  # GET /items or /items.json
  # app/controllers/items_controller.rb
  def index
    @items = Item.all.order(:name) # or whatever ordering you prefer
  end

  # app/controllers/items_controller.rb
  def search
    @items = Item.where("name ILIKE ?", "%#{params[:q]}%")
                 .limit(20)
    render json: @items.as_json(only: [:id, :name, :description, :credit_price, :cash_price])
  end

  # GET /items/1 or /items/1.json
  def show
    @item = Item.find(params[:id])
  end

  def update_menu_category
    @item = Item.find(params[:id])
    @menu = Menu.find(params[:menu_id])
    
    # Find or initialize the menu_item
    menu_item = @item.menu_items.find_or_initialize_by(menu_id: @menu.id)
    
    if params[:item][:menu_category_id].present?
      menu_item.menu_category_id = params[:item][:menu_category_id]
    else
      menu_item.menu_category_id = nil
    end

    if menu_item.save
      redirect_to @item, notice: "Category updated successfully"
    else
      redirect_to @item, alert: "Failed to update category"
    end
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items or /items.json
  def create
    @item = Item.new(item_params)
    if @item.save
      # Redirect to the show page to add prices
      redirect_to @item, notice: "Item created! Please add pricing."
    else
      render :new # Re-render the new form with errors
    end
  end


  # PATCH/PUT /items/1 or /items/1.json
  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      redirect_to @item, notice: "Item updated successfully."
    else
      render :show
    end
  end

  # DELETE /items/1 or /items/1.json
  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    redirect_to items_path, notice: "Item was successfully deleted.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find_by(id: params[:id])
      redirect_to items_path, alert: "Item not found" unless @item
    end

    # Only allow a list of trusted parameters through.
    def item_params
      params.require(:item).permit(:name, :description, :credit_price, :cash_price, :category_id)
    end
end
