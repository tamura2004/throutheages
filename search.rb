require "test/unit"

module YellowTokens
  def eat; [6,4,4,4,4,3,3,3,3,2,2,2,2,1,1,1,1,0,0][yellow]; end
  def cost; [nil,7,7,7,7,5,5,5,5,4,4,4,4,3,3,3,3,2,2][yellow]; end
  def happy; [8,7,7,6,6,5,5,4,4,3,3,2,2,2,2,1,1,0,0][yellow]; end
end

module BlueTokens
  def rotten; [6,4,4,4,4,4,2,2,2,2,2,0,0,0,0,0,0][blue]; end
end

class State < Struct.new(:infantry,:farmer,:food,:miner,:stone,:science,:happy,:worker,:blue,:yellow)
  include YellowTokens
  include BlueTokens
  attr_accessor :prev_state
  def initialize; super(1,2,0,2,0,1,0,1,16,18); end
  def growth
    x = rotten
    if stone >= x
      move(:stone,:blue,x)
    else
      move(:food,:blue,x-stone)
      move(:stone,:blue,stone)
    end
    move(:blue,:food,farmer)
    move(:food,:blue,eat)
    move(:blue,:stone,miner)
  end
  def move(from,to,num)
    x = send(from)
    y = send(to)
    dif = num > x ? x : num
    send("#{from}=",x-dif)
    send("#{to}=",y+dif)
  end
  def to_s
    [:infantry,:farmer,:food,:miner,:stone,:science,:happy,:worker,:blue,:yellow,:rotten,:eat].map do |attr|
      "#{attr}:#{send(attr)}"
    end.join(" ")
  end
end
