require 'test_helper'

class ChoicesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:choices)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create choice" do
    assert_difference('Choice.count') do
      post :create, :choice => { }
    end

    assert_redirected_to choice_path(assigns(:choice))
  end

  test "should show choice" do
    get :show, :id => choices(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => choices(:one).to_param
    assert_response :success
  end

  test "should update choice" do
    put :update, :id => choices(:one).to_param, :choice => { }
    assert_redirected_to choice_path(assigns(:choice))
  end

  test "should destroy choice" do
    assert_difference('Choice.count', -1) do
      delete :destroy, :id => choices(:one).to_param
    end

    assert_redirected_to choices_path
  end
end
