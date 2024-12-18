class AttrColorsController < ApplicationController
  before_action :set_attr_color, only: %i[ update destroy ]

  # POST /attr_colors or /attr_colors.json
  def create
    return unless authenticate_user "Admin"

    @attr_color = AttrColor.new(attr_color_params)

    respond_to do |format|
      if @attr_color.save
        format.html { redirect_to admin_path, notice: "成功创建了一个商品色彩标签" }
        format.json { render :show, status: :created, location: @attr_color }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @attr_color.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /attr_colors/1 or /attr_colors/1.json
  def update
    return unless authenticate_user "Admin"

    respond_to do |format|
      if @attr_color.update(attr_color_params)
        format.html { redirect_to @attr_color, notice: "Attr color was successfully updated." }
        format.json { render :show, status: :ok, location: @attr_color }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @attr_color.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attr_colors/1 or /attr_colors/1.json
  def destroy
    return unless authenticate_user "Admin"
    @attr_color.destroy!

    respond_to do |format|
      format.html { redirect_to admin_path, status: :see_other, notice: "成功删除了一个商品色彩标签" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attr_color
      @attr_color = AttrColor.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def attr_color_params
      params.require(:attr_color).permit(:rgb, :name)
    end
end
