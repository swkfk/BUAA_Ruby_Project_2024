class GoodsController < ApplicationController
  before_action :set_good, only: %i[ show edit update destroy ]

  # GET /goods or /goods.json
  def index
    return unless authenticate_user "Visitor"
    @goods = Good.all
  end

  # GET /goods/1 or /goods/1.json
  def show
    authenticate_user "Merchant", "Admin"
  end

  # GET /goods/new
  def new
    return unless authenticate_user "Merchant", "Admin"

    @good = Good.new
  end

  # GET /goods/1/edit
  def edit
    authenticate_user "Merchant", "Admin"
  end

  # POST /goods or /goods.json
  def create
    return unless authenticate_user "Merchant", "Admin"
    @good = Good.create(name: good_params[:name], price: good_params[:price], description: good_params[:description])

    good_params[:image_ids].each do |image_id|
      image = Image.first(image_id.to_i)
      unless image.nil?
        @good.images << image
      end
    end

    respond_to do |format|
      if @good.save
        format.html { redirect_to @good, notice: "Good was successfully created." }
        format.json { render :show, status: :created, location: @good }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @good.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /goods/1 or /goods/1.json
  def update
    return unless authenticate_user "Merchant", "Admin"
    respond_to do |format|
      if @good.update(good_params)
        format.html { redirect_to @good, notice: "Good was successfully updated." }
        format.json { render :show, status: :ok, location: @good }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @good.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit_good_attribute
    return unless authenticate_user "Merchant", "Admin"
    authenticate_user "Admin", "Merchant"
    @good = Good.find(params[:id])
    if @good.nil?
      redirect_to goods_path
      return
    end
    @tags = AttrTag.all
    @checked_tags = GoodTagRelation.where(good_id: @good.id).map { |relation| relation.attr_tag_id }
    @colors = AttrColor.all
    @checked_colors = GoodColorRelation.where(good_id: @good.id).map { |relation| relation.attr_color_id }
  end

  def do_edit_good_attribute
    return unless authenticate_user "Merchant", "Admin"
    @good = Good.find(params[:id])
    GoodTagRelation.destroy_by(good_id: @good.id)
    GoodColorRelation.destroy_by(good_id: @good.id)
    params[:attr_tag_ids].each do |tag_id|
      GoodTagRelation.create(good_id: @good.id, attr_tag_id: tag_id).save
    end
    params[:attr_color_ids].each do |color_id|
      GoodColorRelation.create(good_id: @good.id, attr_color_id: color_id).save
    end
    redirect_to good_path(@good)
  end

  # DELETE /goods/1 or /goods/1.json
  def destroy
    return unless authenticate_user "Merchant", "Admin"
    @good.destroy!

    respond_to do |format|
      format.html { redirect_to goods_path, status: :see_other, notice: "Good was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_good
      @good = Good.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def good_params
      params.require(:good).permit(:name, :price, :description, image_ids: [])
    end
end
