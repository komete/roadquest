require 'test_helper'

class PointReperesControllerTest < ActionController::TestCase
  setup do
    @point_repere = point_reperes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:point_reperes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create point_repere" do
    assert_difference('PointRepere.count') do
      post :create, point_repere: { latitude: @point_repere.latitude, longitude: @point_repere.longitude, projection: @point_repere.projection }
    end

    assert_redirected_to point_repere_path(assigns(:point_repere))
  end

  test "should show point_repere" do
    get :show, id: @point_repere
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @point_repere
    assert_response :success
  end

  test "should update point_repere" do
    patch :update, id: @point_repere, point_repere: { latitude: @point_repere.latitude, longitude: @point_repere.longitude, projection: @point_repere.projection }
    assert_redirected_to point_repere_path(assigns(:point_repere))
  end

  test "should destroy point_repere" do
    assert_difference('PointRepere.count', -1) do
      delete :destroy, id: @point_repere
    end

    assert_redirected_to point_reperes_path
  end
end
