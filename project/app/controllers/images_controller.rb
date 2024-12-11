class ImagesController < ApplicationController
  def index
    authenticate_user
    @images = Image.where(user_id: session[:current_userid])
  end

  def delete
    image = Image.find(params[:id].to_i)
    if image && image.user_id == session[:current_userid]
      image.destroy!
    end
    redirect_to "/image/index"
  end

  def create
    @image = Image.new(user_id: params[:user_id].to_i, file: params[:file], title: params[:title])
    @image.save!
    redirect_to "/image/index"
  end
end
