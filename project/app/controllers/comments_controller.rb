class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ update destroy ]

  # POST /comments or /comments.json
  def create
    return unless authenticate_user "Customer"

    unless comment_params[:user_id] == session[:current_userid].to_s
      redirect_to goods_path, notice: "你不能使用其他用户的 ID 发表评论，你在做什么？"
      return
    end
    @comment = Comment.new(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to goods_path, notice: "成功发表评论" }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    return unless (authenticate_user "Admin", "Customer") && (assert_current_user @comment.user_id, "Admin")

    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to goods_path, notice: "成功更新评论" }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    return unless (authenticate_user "Admin", "Customer") && (assert_current_user @comment.user_id, "Admin")

    @comment.destroy!

    respond_to do |format|
      format.html { redirect_to goods_path, status: :see_other, notice: "成功删除评论" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:user_id, :good_id, :content, :score)
    end
end
