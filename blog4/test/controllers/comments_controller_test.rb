require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:one)
    @blog = blogs(:one)
    @comment = comments(:one)
    @comment.blog = @blog
  end

  test "should get index" do
    get blog_comments_url @blog.id
    assert_response :success
  end

  test "should get new" do
    get new_blog_comment_url(@blog.id)
    assert_response :success
  end

  test "should create comment" do
    assert_difference("Comment.count") do
      post blog_comments_url(@blog.id), params: { comment: { blog_id: @comment.blog_id, content: @comment.content } }
    end

    assert_redirected_to blog_url(@blog.id)
  end

  test "should show comment" do
    get blog_comment_url(@blog, @comment)
    assert_response :success
  end

  test "should get edit" do
    get edit_blog_comment_url(@blog, @comment)
    assert_response :success
  end

  test "should update comment" do
    patch blog_comment_url(@blog, @comment), params: { comment: { blog_id: @comment.blog_id, content: @comment.content } }
    assert_redirected_to blog_comment_url(@comment.blog_id, @comment)
  end

  test "should destroy comment" do
    assert_difference("Comment.count", -1) do
      delete blog_comment_url(@comment.blog_id, @comment)
    end

    assert_redirected_to blog_url
  end
end
