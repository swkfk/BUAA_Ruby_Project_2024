class FavoriteItemsController < ApplicationController
  before_action :set_favorite_item, only: %i[ show destroy ]

  # GET /favorite_items or /favorite_items.json
  def index
    return unless authenticate_user "Customer"
    @favorite_items = FavoriteItem.all
  end

  # GET /favorite_items/1 or /favorite_items/1.json
  def show
  end

  # GET /favorite_items/new
  def new
    @favorite_item = FavoriteItem.new
  end

  # POST /favorite_items or /favorite_items.json
  def create
    return unless authenticate_user "Customer"
    @favorite_item = FavoriteItem.new(favorite_item_params)

    respond_to do |format|
      if @favorite_item.save
        format.html { redirect_to goods_path, notice: "Favorite item was successfully created." }
        format.json { render :show, status: :created, location: @favorite_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @favorite_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /favorite_items/1 or /favorite_items/1.json
  def destroy
    return unless (authenticate_user "Customer") && (assert_current_user @favorite_item.user_id)
    redirect_target = params[:redirect].to_i == 1 ? goods_path : favorite_items_path
    @favorite_item.destroy!

    respond_to do |format|
      format.html { redirect_to redirect_target, status: :see_other, notice: "Favorite item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_favorite_item
      @favorite_item = FavoriteItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def favorite_item_params
      params.require(:favorite_item).permit(:user_id, :good_id)
    end
end
