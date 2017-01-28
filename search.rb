require "test/unit"

class Tokens < Struct.new(:number)
  include Comparable
  def <=>(other);number - other.to_i; end
  def to_i;number;end
  def ==(other); number == other.to_i; end
  def +(other); number + other.to_i; end
  def -(other); number - other.to_i; end
  def *(other); number * other.to_i; end
  def move(other,n)
    raise unless other.kind_of? Tokens
    n = n.to_i
    x = n > number ? number : n
    self.number -= x
    other.number += x
  end
  def coerce(other)
    if other.kind_of? Numeric
      [other,number]
    else
      raise
    end
  end
end

class YellowTokens < Tokens
  def initialize; super(18); end
  def eat; [6,4,4,4,4,3,3,3,3,2,2,2,2,1,1,1,1,0,0][number]; end
  def cost; [nil,7,7,7,7,5,5,5,5,4,4,4,4,3,3,3,3,2,2][number]; end
  def happy; [8,7,7,6,6,5,5,4,4,3,3,2,2,2,2,1,1,0,0][number]; end
end

class BlueTokens < Tokens
  def initialize; super(16); end
  def rotten; [6,4,4,4,4,4,2,2,2,2,2,0,0,0,0,0,0][number]; end
end

class State < Struct.new(:infantry,:farmer,:food,:miner,:stone,:science,:happy,:worker,:blue,:yellow)
  attr_accessor :prev_state
  def initialize
    super(1,2,Tokens.new(0),2,Tokens.new(0),1,0,1,BlueTokens.new,YellowTokens.new)
  end
  def growth
    if blue.rotten > 0
      rotten = blue.rotten
      if stone >= rotten
        stone.move(blue,rotten)
      else
        rotten -= stone
        stone.move(blue,stone)
        food.move(blue,rotten)
      end
    end
    blue.move(food,farmer)
    food.move(blue,yellow.eat)
    blue.move(stone,miner)
  end
end
