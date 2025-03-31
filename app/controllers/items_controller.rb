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
    # Render the editable form view
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
      render :show, status: :unprocessable_entity
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
      @item = Item.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def item_params
      params.require(:item).permit(:name, :description, :credit_price, :cash_price)
    end
end
