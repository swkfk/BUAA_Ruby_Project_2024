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
        format.html { redirect_to goods_path, notice: "成功创建了一个购物车项" }
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

    redirect_target = params[:redirect].to_i == 1 ? goods_path : cart_items_path

    unless @cart_item.user_id == session[:current_userid]
      redirect_to redirect_target, notice: "你只能修改属于自己的购物车项，你在做什么？"
      return
    end
    if cart_item_params[:count].to_i < 1
      @cart_item.destroy!
      redirect_to redirect_target, notice: "已删除该购物车项"
      return
    end
    respond_to do |format|
      if @cart_item.update(cart_item_params)
        format.html { redirect_to redirect_target, notice: "成功更新了购买数量" }
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
      format.html { redirect_to cart_items_path, status: :see_other, notice: "成功移除了该购买内容" }
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
