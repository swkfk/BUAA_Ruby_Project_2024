require "test_helper"

class AttrTagsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @attr_tag = attr_tags(:one)
  end

  test "should get index" do
    get attr_tags_url
    assert_response :success
  end

  test "should get new" do
    get new_attr_tag_url
    assert_response :success
  end

  test "should create attr_tag" do
    assert_difference("AttrTag.count") do
      post attr_tags_url, params: { attr_tag: { name: @attr_tag.name } }
    end

    assert_redirected_to attr_tag_url(AttrTag.last)
  end

  test "should show attr_tag" do
    get attr_tag_url(@attr_tag)
    assert_response :success
  end

  test "should get edit" do
    get edit_attr_tag_url(@attr_tag)
    assert_response :success
  end

  test "should update attr_tag" do
    patch attr_tag_url(@attr_tag), params: { attr_tag: { name: @attr_tag.name } }
    assert_redirected_to attr_tag_url(@attr_tag)
  end

  test "should destroy attr_tag" do
    assert_difference("AttrTag.count", -1) do
      delete attr_tag_url(@attr_tag)
    end

    assert_redirected_to attr_tags_url
  end
end
