require 'test_helper'

class PitchingsControllerTest < ActionController::TestCase
  setup do
    @pitching = pitchings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pitchings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pitching" do
    assert_difference('Pitching.count') do
      post :create, pitching: { league: @pitching.league, playerID: @pitching.playerID, teamID: @pitching.teamID, yearID: @pitching.yearID }
    end

    assert_redirected_to pitching_path(assigns(:pitching))
  end

  test "should show pitching" do
    get :show, id: @pitching
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @pitching
    assert_response :success
  end

  test "should update pitching" do
    patch :update, id: @pitching, pitching: { league: @pitching.league, playerID: @pitching.playerID, teamID: @pitching.teamID, yearID: @pitching.yearID }
    assert_redirected_to pitching_path(assigns(:pitching))
  end

  test "should destroy pitching" do
    assert_difference('Pitching.count', -1) do
      delete :destroy, id: @pitching
    end

    assert_redirected_to pitchings_path
  end
end
