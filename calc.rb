class Bank < Struct.new(:number,:color)
  include Comparable

  def <=>(other)
    case other
    when Bank then number - other.number
    when Numeric then number - other
    end
  end

  def +(other)
    case other
    when Bank then number + other.number
    when Numeric then number + other
    end
  end

  def *(other)
    case other
    when Bank then number * other.number
    when Numeric then number * other
    end
  end

  def coerce
    number
  end

  def to_i
    number.to_i
  end

  def move(other,amount)
    x = [number,amount].min
    self.number -= x
    other.number += x
  end
end

class YellowBank < Bank
  def happy; if number <= 14 then 8 - (number+1)/2 else 9 - (number+1)/2 end; end
  def eat; if number.zero? then 6 else 4 - (number - 1)/4 end; end
  def cost; if number <= 6 then 7 else 6 - (number - 1)/4 end; end
end

class BlueBank < Bank
  def corruption
    6 - (number + 4)/5*2
  end
end

class Place
  attr_accessor :yellow, :blue
  def initialize(yellow,blue)
    @yellow = Bank.new(yellow)
    @blue = Bank.new(blue)
  end
end

class Player
  attr_accessor :warriors, :agriculture, :bronze, :philosophy, :religion, :yellow_bank, :blue_bank
  def initialize
    @warrior = Bank.new(1,:yellow)
    @farmer = Bank.new(2,:yellow)
    @miner = Bank.new(2,:yellow)
    @worker = Bank.new(1,:yellow)

    @food = Bank.new(0,:blue)
    @gold = Bank.new(0,:blue)

    @science = Bank.new(1,nil)
    @happy = Bank.new(0,nil)

    @yellow = YellowBank.new(18,:yellow)
    @blue = BlueBank.new(18,:blue)
  end

  def use_food
    while @food >= @yellow.cost && @yellow > 0
      @food.move(@blue, @yellow.cost)
      @yellow.move(@worker, 1)
    end
  end

  def use_worker
    while @worker > 0 && @yellow.happy >= @happy + @worker && @gold >= 3
      @worker.move(@happy,1)
      @gold.move(@blue,3)
    end

    while @worker > 0 && @yellow.happy < @happy + @worker && @gold >= 2
      if @farmer <= @yellow.eat
        @worker.move(@farmer,1)
        @gold.move(@blue,2)
      elsif @miner < 3
        @worker.move(@miner,1)
        @gold.move(@blue,2)
      else
        break
      end
    end
  end

  def corruption
    x = @blue.corruption
    printf("corruption:%d\n",x) if x > 0
    while x > 0
      if @gold > 0
        @gold.move(@blue, 1)
      else
        @food.move(@blue,1)
      end
      x -= 1
    end
  end

  def create_food
    @blue.move(@food, @farmer.number)
  end

  def display
    printf("food:%d/%d gold:%d/%d happy:%d worker:%d blue:%d yellow:%d\n",@food,@farmer,@gold,@miner,@happy,@worker,@blue,@yellow)
  end

  def eat_food
    @food.move(@blue, @yellow.eat)
  end

  def create_gold
    @blue.move(@gold, @miner.number)
  end

  def take_turn
    use_food
    use_worker
    display
    if @yellow.happy <= @happy + @worker
      corruption
      create_food
      eat_food
      create_gold
    end
  end
end

player = Player.new
20.times do |i|
  print i.to_s + ":"
  player.take_turn
end
