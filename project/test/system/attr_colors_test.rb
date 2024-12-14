require "application_system_test_case"

class AttrColorsTest < ApplicationSystemTestCase
  setup do
    @attr_color = attr_colors(:one)
  end

  test "visiting the index" do
    visit attr_colors_url
    assert_selector "h1", text: "Attr colors"
  end

  test "should create attr color" do
    visit attr_colors_url
    click_on "New attr color"

    fill_in "Name", with: @attr_color.name
    fill_in "Rgb", with: @attr_color.rgb
    click_on "Create Attr color"

    assert_text "Attr color was successfully created"
    click_on "Back"
  end

  test "should update Attr color" do
    visit attr_color_url(@attr_color)
    click_on "Edit this attr color", match: :first

    fill_in "Name", with: @attr_color.name
    fill_in "Rgb", with: @attr_color.rgb
    click_on "Update Attr color"

    assert_text "Attr color was successfully updated"
    click_on "Back"
  end

  test "should destroy Attr color" do
    visit attr_color_url(@attr_color)
    click_on "Destroy this attr color", match: :first

    assert_text "Attr color was successfully destroyed"
  end
end
