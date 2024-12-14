class ImagesController < ApplicationController
  def index
    return unless authenticate_user
    @images = Image.where(user_id: session[:current_userid])
  end

  def destroy
    image = Image.find(params[:id].to_i)
    return unless authenticate_user && assert_current_user(image.user_id)

    image.destroy!
    redirect_to images_path, notice: "成功删除图片"
  end

  def create
    return unless authenticate_user
    @image = Image.new(user_id: params[:user_id].to_i, file: params[:file], title: params[:title])
    @image.save!
    redirect_to images_path, notice: "成功上传图片"
  end
end
