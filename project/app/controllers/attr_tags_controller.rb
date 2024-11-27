class AttrTagsController < ApplicationController
  before_action :set_attr_tag, only: %i[ show edit update destroy ]

  # GET /attr_tags or /attr_tags.json
  def index
    @attr_tags = AttrTag.all
  end

  # GET /attr_tags/1 or /attr_tags/1.json
  def show
  end

  # GET /attr_tags/new
  def new
    @attr_tag = AttrTag.new
  end

  # GET /attr_tags/1/edit
  def edit
  end

  # POST /attr_tags or /attr_tags.json
  def create
    @attr_tag = AttrTag.new(attr_tag_params)

    respond_to do |format|
      if @attr_tag.save
        format.html { redirect_to @attr_tag, notice: "Attr tag was successfully created." }
        format.json { render :show, status: :created, location: @attr_tag }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @attr_tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /attr_tags/1 or /attr_tags/1.json
  def update
    respond_to do |format|
      if @attr_tag.update(attr_tag_params)
        format.html { redirect_to @attr_tag, notice: "Attr tag was successfully updated." }
        format.json { render :show, status: :ok, location: @attr_tag }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @attr_tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attr_tags/1 or /attr_tags/1.json
  def destroy
    @attr_tag.destroy!

    respond_to do |format|
      format.html { redirect_to attr_tags_path, status: :see_other, notice: "Attr tag was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attr_tag
      @attr_tag = AttrTag.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def attr_tag_params
      params.require(:attr_tag).permit(:name)
    end
end
