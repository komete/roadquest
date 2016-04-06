require 'test_helper'

class TronconRoutesControllerTest < ActionController::TestCase
  setup do
    @troncon_route = troncon_routes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:troncon_routes)
  end

  test "should show troncon_route" do
    get :show, id: @troncon_route
    assert_response :success
  end

end
