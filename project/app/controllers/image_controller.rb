class ImageController < ApplicationController
  def index
    authenticate_user
    @images = Image.where(user_id: session[:current_userid])
  end

  def new
    @image = Image.new
  end

  def create
    puts ">>>> Enter! <<<<"
    @image = Image.new(user_id: params[:user_id], file: params[:file])
    puts ">>>> Created! <<<<"
    @image.save!
    puts ">>>> Saved! <<<<"
    redirect_to "/image/index"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image
      @image = Image.find(params[:id])
    end
end
