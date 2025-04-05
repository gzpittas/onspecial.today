class ItemsController < ApplicationController
  before_action :set_item, only: %i[ show edit update destroy ]

  def search
    query = params[:q].to_s.strip
    return render json: { error: "Query too short" }, status: :bad_request if query.length < 3

    @items = Item.where("name ILIKE ?", "%#{query}%")
                 .includes(:category)
                 .limit(20)

    render json: {
      items: @items.map { |item| 
        {
          id: item.id,
          name: item.name,
          description: item.description,
          credit_price: item.credit_price.to_f,
          cash_price: item.cash_price.to_f,
          category_id: item.category&.id
        }
      }
    }
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

   # GET /items
  def index
    @items = Item.includes(:category).all.order(:name)
    @highlight_item = params[:highlight]
    @open_category = params[:open_category]
  end

  # GET /items/new
  def new
    @item = Item.new
    render 'show' # This will use the show template for new items
  end

  # GET /items/1/edit
  def edit
    @item = Item.find(params[:id])
    render 'show' # This will use the show template for editing
  end

  # POST /items or /items.json
  # app/controllers/items_controller.rb
  def create
    @item = Item.new(item_params)
    
    if @item.save
      redirect_to @item, notice: 'Item created successfully'
    else
      # This preserves all validation errors including any uniqueness errors
      # that were caught by Rails validations (not database level)
      render :new, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotUnique => e
    # This catches database-level uniqueness violations that bypass Rails validations
    @item.errors.add(:name, 'already exists')
    render :new, status: :unprocessable_entity
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

  # app/controllers/items_controller.rb
  def check_name
    name = params[:name].to_s.strip
    item = Item.where('LOWER(name) = ?', name.downcase).first
    exists = item.present?
    
    render json: { 
      exists: exists,
      item_id: item&.id,
      category_id: item&.category_id
    }
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
