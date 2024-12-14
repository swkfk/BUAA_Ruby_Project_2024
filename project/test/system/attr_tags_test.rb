require "application_system_test_case"

class AttrTagsTest < ApplicationSystemTestCase
  setup do
    @attr_tag = attr_tags(:one)
  end

  test "visiting the index" do
    visit attr_tags_url
    assert_selector "h1", text: "Attr tags"
  end

  test "should create attr tag" do
    visit attr_tags_url
    click_on "New attr tag"

    fill_in "Name", with: @attr_tag.name
    click_on "Create Attr tag"

    assert_text "Attr tag was successfully created"
    click_on "Back"
  end

  test "should update Attr tag" do
    visit attr_tag_url(@attr_tag)
    click_on "Edit this attr tag", match: :first

    fill_in "Name", with: @attr_tag.name
    click_on "Update Attr tag"

    assert_text "Attr tag was successfully updated"
    click_on "Back"
  end

  test "should destroy Attr tag" do
    visit attr_tag_url(@attr_tag)
    click_on "Destroy this attr tag", match: :first

    assert_text "Attr tag was successfully destroyed"
  end
end
