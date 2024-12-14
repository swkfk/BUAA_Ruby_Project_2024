class OrdersController < ApplicationController
  before_action :set_order, only: %i[ show edit update destroy ]

  # GET /orders or /orders.json
  def index
    authenticate_user "Customer", "Merchant"
    @orders = Order.all
  end

  # GET /orders/1 or /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
    (authenticate_user "Customer") && (assert_current_user @order.user_id)
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    return unless (authenticate_user "Customer") && (assert_current_user @order.user_id)
    if params[:order][:name].empty?
      redirect_to new_order_path, notice: "收货人不能为空"
      return
    end
    params[:order].each do |good_id, count|
      # It is terrible to use this way! But I have no time to fix it.
      if good_id == "user_id" || good_id == "name" || good_id == "address" || good_id == "phone" || good_id.nil? || count.nil?
        next
      end
      good_id = good_id.to_i
      count = count.to_i

      unless count <= 0
        order_item = OrderItem.where(order_id: @order.id, good_id: good_id).first
        if order_item.nil?
          OrderItem.create!(order_id: @order.id, good_id: good_id, count: count)
        elsif count == 0
          order_item.destroy!
        else
          order_item.update(count: count)
          order_item.save!
        end
      end
    end
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to orders_path, notice: "成功更新订单内容" }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    return unless (authenticate_user "Customer") && (assert_current_user @order.user_id)
    @order.destroy!

    respond_to do |format|
      format.html { redirect_to orders_path, status: :see_other, notice: "成功删除订单" }
      format.json { head :no_content }
    end
  end

  def do_create_order
    authenticate_user "Customer"
    if params[:name].empty?
      redirect_to new_order_path, notice: "收货人不能为空"
      return
    end
    @order = Order.new(user_id: session[:current_userid], name: params[:name], address: params[:address], phone: params[:phone])
    @order.save!
    params[:items].each do |good_id, count|
      unless good_id.nil? || count.nil? || count.to_i <= 0
        OrderItem.create!(order_id: @order.id, good_id: good_id, count: count.to_i)
      end
    end
    redirect_to orders_path, notice: "成功创建订单"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:user_id, :name, :address, :phone)
    end
end
