require 'test_helper'

class BattingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'First playerID is aardsda01' do
    m = Batting.first
    assert_equal(m.playerID, 'aardsda01', 'ID didn\'t match')
  end

  test 'Last playerID is zumayjo01' do
    m = Batting.last
    assert_equal(m.playerID, 'zumayjo01', 'ID matched')
  end

  test "First Most improved ba from 2009 to 2010" do
    most_improved_ba = Batting.most_improved_ba_from(2009, 2010, 1).first
    assert_equal(most_improved_ba.playerID, 'hamiljo03', 'First batter was not hamiljo03')
  end

  test "Last Most improved ba from 2009 to 2010" do
    most_improved_ba = Batting.most_improved_ba_from(2009, 2010, 50000).last
    assert_equal(most_improved_ba.playerID, 'sweenry01', 'Last batter was not sweenry01')
  end

  test "Best Slugging Percentage for Oakland A's with available stats in 2007" do
    best_slugging_pct = Batting.slugging_pct_for_team_and_year('OAK', 2007).first
    assert_equal(best_slugging_pct.playerID, 'kennejo04', 'Best Oakland slugging pct was not kennejo04')
  end

  test "Worst Slugging Percentage for Oakland A's with available stats in 2007" do
    best_slugging_pct = Batting.slugging_pct_for_team_and_year('OAK', 2007).last
    assert_equal(best_slugging_pct.playerID, 'witasja01', 'Best Oakland slugging pct was not witasja01')
  end

  test "Triple Crown winner for 2011 with AB of 400" do
    tcw = Batting.triple_crown(2011, 400)
    assert_equal(tcw, nil, 'TCW for 2011 with AB of 400 was not = nil')
  end

  test "Triple Crown winner for 2011 with AB of 600" do
    tcw = Batting.triple_crown(2011, 600)
    assert_equal(tcw, nil, 'TCW for 2011 with AB of 400 was not = nil')
  end

  test "Triple Crown winner for 2012 with AB of 600" do
    tcw = Batting.triple_crown(2012, 600)
    assert_equal(tcw, 'cabremi01', 'TCW for 2011 with AB of 400 was not = cabremi01')
  end

end
