require 'test_helper'

class MasterTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "First ID is aardsda01" do
    m = Master.first
    assert_equal(m.id, "aardsda01", "ID matched")
  end

  test "Last ID is zwilldu01" do
    m = Master.last
    assert_equal(m.id, "zwilldu01", "ID matched")
  end
end
