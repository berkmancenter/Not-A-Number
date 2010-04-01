require 'test_helper'

class QuestionItemsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:question_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create question_item" do
    assert_difference('QuestionItem.count') do
      post :create, :question_item => { }
    end

    assert_redirected_to question_item_path(assigns(:question_item))
  end

  test "should show question_item" do
    get :show, :id => question_items(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => question_items(:one).to_param
    assert_response :success
  end

  test "should update question_item" do
    put :update, :id => question_items(:one).to_param, :question_item => { }
    assert_redirected_to question_item_path(assigns(:question_item))
  end

  test "should destroy question_item" do
    assert_difference('QuestionItem.count', -1) do
      delete :destroy, :id => question_items(:one).to_param
    end

    assert_redirected_to question_items_path
  end
end
