require "./search.rb"

class TestYellowTokens < Test::Unit::TestCase
  def test_eat
    state = State.new
    assert_equal 0, state.eat
    state.yellow = 1
    assert_equal 4, state.eat
    state.yellow = 0
    assert_equal 6, state.eat
  end

  def test_cost
    state = State.new
    assert_equal 2, state.cost
    state.yellow = 1
    assert_equal 7, state.cost
    state.yellow = 0
    assert_equal nil, state.cost
  end

  def test_happy
    state = State.new
    assert_equal 0, state.happy
    state.yellow = 1
    assert_equal 7, state.happy
    state.yellow = 0
    assert_equal 8, state.happy
  end
end

class TestBlueTokens < Test::Unit::TestCase
  def test_rotten
    state = State.new
    assert_equal 0, state.rotten
    state.blue = 1
    assert_equal 4, state.rotten
    state.blue = 0
    assert_equal 6, state.rotten
  end
end

class TestState < Test::Unit::TestCase
  def test_initialize
    state = State.new
    assert_equal 1,state.infantry
    assert_equal 2,state.farmer
    assert_equal 0,state.food
    assert_equal 2,state.miner
    assert_equal 0,state.stone
    assert_equal 1,state.labo
    assert_equal 0,state.religion
    assert_equal 1,state.worker
    assert_equal 16,state.blue
    assert_equal 18,state.yellow
    assert_equal nil, state.prev_state

    state.move(:blue,:food,10)
    state_2 = State[state]
    state_2.move(:food,:blue,5)

    assert_equal 10,state.food
    assert_equal 5, state_2.food
    assert_equal state,state_2.prev_state
  end
  def test_growth
    state = State.new
    7.times{state.growth}
    assert_equal state.food, 10
    assert_equal state.stone, 2
    assert_equal state.blue, 4
    assert_equal state.rotten, 4
  end
  def test_move
    state = State.new
    state.move(:yellow,:farmer,10)
    assert_equal 8, state.yellow
    assert_equal 12, state.farmer
  end
end
