require "./search.rb"

class TestState < Test::Unit::TestCase
  def test_initialize
    state = State.new
    assert_equal 1,state.infantry
    assert_equal 2,state.farmer
    assert_equal 0,state.food
    assert_equal 2,state.miner
    assert_equal 0,state.stone
    assert_equal 1,state.science
    assert_equal 0,state.happy
    assert_equal 1,state.worker
    assert_equal 16,state.blue
    assert_equal 18,state.yellow
  end

  def test_growth
    state = State.new
    7.times{state.growth}
    assert_equal state.food, 10
    assert_equal state.stone, 2
    assert_equal state.blue, 4
    assert_equal state.rotten, 4

  end
end
