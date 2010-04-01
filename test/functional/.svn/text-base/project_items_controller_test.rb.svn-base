require 'test_helper'

class ProjectItemsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:project_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create project_item" do
    assert_difference('ProjectItem.count') do
      post :create, :project_item => { }
    end

    assert_redirected_to project_item_path(assigns(:project_item))
  end

  test "should show project_item" do
    get :show, :id => project_items(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => project_items(:one).to_param
    assert_response :success
  end

  test "should update project_item" do
    put :update, :id => project_items(:one).to_param, :project_item => { }
    assert_redirected_to project_item_path(assigns(:project_item))
  end

  test "should destroy project_item" do
    assert_difference('ProjectItem.count', -1) do
      delete :destroy, :id => project_items(:one).to_param
    end

    assert_redirected_to project_items_path
  end
end
