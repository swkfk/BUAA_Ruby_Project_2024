require "test_helper"

class AttrColorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @attr_color = attr_colors(:one)
  end

  test "should get index" do
    get attr_colors_url
    assert_response :success
  end

  test "should get new" do
    get new_attr_color_url
    assert_response :success
  end

  test "should create attr_color" do
    assert_difference("AttrColor.count") do
      post attr_colors_url, params: { attr_color: { name: @attr_color.name, rgb: @attr_color.rgb } }
    end

    assert_redirected_to attr_color_url(AttrColor.last)
  end

  test "should show attr_color" do
    get attr_color_url(@attr_color)
    assert_response :success
  end

  test "should get edit" do
    get edit_attr_color_url(@attr_color)
    assert_response :success
  end

  test "should update attr_color" do
    patch attr_color_url(@attr_color), params: { attr_color: { name: @attr_color.name, rgb: @attr_color.rgb } }
    assert_redirected_to attr_color_url(@attr_color)
  end

  test "should destroy attr_color" do
    assert_difference("AttrColor.count", -1) do
      delete attr_color_url(@attr_color)
    end

    assert_redirected_to attr_colors_url
  end
end
