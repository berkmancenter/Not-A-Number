require 'test_helper'

class GroupItemsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:group_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create group_item" do
    assert_difference('GroupItem.count') do
      post :create, :group_item => { }
    end

    assert_redirected_to group_item_path(assigns(:group_item))
  end

  test "should show group_item" do
    get :show, :id => group_items(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => group_items(:one).to_param
    assert_response :success
  end

  test "should update group_item" do
    put :update, :id => group_items(:one).to_param, :group_item => { }
    assert_redirected_to group_item_path(assigns(:group_item))
  end

  test "should destroy group_item" do
    assert_difference('GroupItem.count', -1) do
      delete :destroy, :id => group_items(:one).to_param
    end

    assert_redirected_to group_items_path
  end
end
