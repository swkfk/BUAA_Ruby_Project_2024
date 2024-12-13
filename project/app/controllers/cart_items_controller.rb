class CartItemsController < ApplicationController
  before_action :set_cart_item, only: %i[ update destroy ]

  # GET /cart_items or /cart_items.json
  def index
    return unless authenticate_user "Customer"

    @cart_items = CartItem.all
  end

  # POST /cart_items or /cart_items.json
  def create
    return unless authenticate_user "Customer"

    @cart_item = CartItem.new(cart_item_params)

    respond_to do |format|
      if @cart_item.save
        format.html { redirect_to goods_path, notice: "Cart item was successfully created." }
        format.json { render :show, status: :created, location: @cart_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @cart_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cart_items/1 or /cart_items/1.json
  def update
    return unless (authenticate_user "Customer") && (assert_current_user @cart_item.user_id)

    unless @cart_item.user_id == session[:current_userid]
      redirect_to goods_path, notice: "You can only update your own cart items."
      return
    end
    if cart_item_params[:count].to_i < 1
      @cart_item.destroy!
      redirect_to goods_path, notice: "Cart item was successfully destroyed."
      return
    end
    respond_to do |format|
      if @cart_item.update(cart_item_params)
        format.html { redirect_to goods_path, notice: "Cart item was successfully updated." }
        format.json { render :show, status: :ok, location: @cart_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cart_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cart_items/1 or /cart_items/1.json
  def destroy
    return unless (authenticate_user "Customer") && (assert_current_user @cart_item.user_id)

    @cart_item.destroy!

    respond_to do |format|
      format.html { redirect_to cart_items_path, status: :see_other, notice: "Cart item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cart_item
      @cart_item = CartItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cart_item_params
      params.require(:cart_item).permit(:user_id, :good_id, :count)
    end
end
