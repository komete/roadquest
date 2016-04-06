require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test "should get acceuil" do
    get :acceuil
    assert_response :success
    assert_select "title", "RoadQuest"
  end

  test "should get recherches" do
    get :recherches
    assert_response :success
    assert_select "title", "Recherche"
  end
end
