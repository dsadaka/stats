require 'test_helper'

class BattingsControllerTest < ActionController::TestCase
  setup do
    @batting = battings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:battings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create batting" do
    assert_difference('Batting.count') do
      post :create, batting: { AB: @batting.AB, CS: @batting.CS, G: @batting.G, H: @batting.H, HR: @batting.HR, R: @batting.R, RBI: @batting.RBI, SB: @batting.SB, league: @batting.league, playerID: @batting.playerID, teamID: @batting.teamID, threeB: @batting.threeB, twoB: @batting.twoB, yearID: @batting.yearID }
    end

    assert_redirected_to batting_path(assigns(:batting))
  end

  test "should show batting" do
    get :show, id: @batting
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @batting
    assert_response :success
  end

  test "should update batting" do
    patch :update, id: @batting, batting: { AB: @batting.AB, CS: @batting.CS, G: @batting.G, H: @batting.H, HR: @batting.HR, R: @batting.R, RBI: @batting.RBI, SB: @batting.SB, league: @batting.league, playerID: @batting.playerID, teamID: @batting.teamID, threeB: @batting.threeB, twoB: @batting.twoB, yearID: @batting.yearID }
    assert_redirected_to batting_path(assigns(:batting))
  end

  test "should destroy batting" do
    assert_difference('Batting.count', -1) do
      delete :destroy, id: @batting
    end

    assert_redirected_to battings_path
  end
end
