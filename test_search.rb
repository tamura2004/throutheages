require "./search.rb"
class TestTokens < Test::Unit::TestCase
  def test_eql
    x = Tokens.new(10)
    y = Tokens.new(10)
    assert_equal x, y
    assert_equal x, 10
    assert_equal 10, x
  end

  def test_plus
    x = Tokens.new(10)
    y = Tokens.new(10)
    assert_equal x + y, 20
    assert_equal x + 1, 11
    assert_equal 1 + x, 11
  end

  def test_minus
    x = Tokens.new(10)
    y = Tokens.new(10)
    assert_equal x - y, 0
    assert_equal x - 1, 9
    assert_equal 20 - x, 10
  end

  def test_power
    x = Tokens.new(10)
    y = Tokens.new(10)
    assert_equal x * y, 100
    assert_equal x * 2, 20
    assert_equal 2 * x, 20
  end

  def test_move
    x = Tokens.new(11)
    y = Tokens.new(7)
    z = Tokens.new(5)
    x.move(y,z)
    assert_equal x, 6
    assert_equal y, 12

    y.move(x,13)
    assert_equal y,0
    assert_equal x,18
  end


end

class TestYellowTokens < Test::Unit::TestCase
  def test_initialize
    yellow = YellowTokens.new
    other = Tokens.new(0)
    assert_equal 18,yellow.number
    assert_equal 0,yellow.eat
    assert_equal 2,yellow.cost
    assert_equal 0,yellow.happy

    yellow.move(other,18)
    assert_equal 0,yellow.number
    assert_equal 6,yellow.eat
    assert_equal nil,yellow.cost
    assert_equal 8,yellow.happy
  end
end

class TestBlueTokens < Test::Unit::TestCase
  def test_initialize
    blue = BlueTokens.new
    other = Tokens.new(0)
    assert_equal 16,blue.number
    assert_equal 0,blue.rotten

    blue.move(other,6)
    assert_equal 10,blue.number
    assert_equal 2,blue.rotten

    blue.move(other,10)
    assert_equal 0,blue.number
    assert_equal 6,blue.rotten
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
    assert_equal 1,state.science
    assert_equal 0,state.happy
    assert_equal 1,state.worker
    assert_equal 16,state.blue
    assert_equal 18,state.yellow
  end

  def test_growth
    state = State.new
    state.growth
    assert_equal state.food, 2
    assert_equal state.stone, 2
    assert_equal state.blue, 12
    assert_equal state.blue.rotten, 0

    state.growth
    assert_equal state.food, 4
    assert_equal state.stone, 4
    assert_equal state.blue, 8
    assert_equal state.blue.rotten, 2

    state.growth
    assert_equal state.food, 6
    assert_equal state.stone, 4
    assert_equal state.blue, 6
    assert_equal state.blue.rotten, 2

    state.growth
    assert_equal state.food, 8
    assert_equal state.stone, 4
    assert_equal state.blue, 4
    assert_equal state.blue.rotten, 4

    state.growth
    assert_equal state.food, 10
    assert_equal state.stone, 2
    assert_equal state.blue, 4
    assert_equal state.blue.rotten, 4

    state.growth
    assert_equal state.food, 10
    assert_equal state.stone, 2
    assert_equal state.blue, 4
    assert_equal state.blue.rotten, 4

  end
end
