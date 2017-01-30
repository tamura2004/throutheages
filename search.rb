require "test/unit"

module YellowTokens
  def eat; [6,4,4,4,4,3,3,3,3,2,2,2,2,1,1,1,1,0,0][yellow]; end
  def cost(unit)
    case unit
    when :worker
      [99,7,7,7,7,5,5,5,5,4,4,4,4,3,3,3,3,2,2][yellow]
    when :infantry,:farmer,:miner then 2
    when :labo,:religion then 3
    end
  end
  def happy; [8,7,7,6,6,5,5,4,4,3,3,2,2,2,2,1,1,0,0][yellow]; end
end

module BlueTokens
  def rotten; [6,4,4,4,4,4,2,2,2,2,2,0,0,0,0,0,0][blue]; end
end

class State < Struct.new(:infantry,:farmer,:food,:miner,:stone,:labo,:religion,:worker,:blue,:yellow)
  include YellowTokens
  include BlueTokens
  attr_accessor :prev_state,:turn,:action,:science

  def initialize(prev_state=nil)
    if prev_state.kind_of? State
      super(*prev_state.values)
      @prev_state = prev_state
      @turn = prev_state.turn
    else
      super(1,2,0,2,0,1,0,1,16,18)
      @turn = 1
    end
    @action = ""
    @science = 0
  end

  def growth
    self.turn += 1
    self.science += labo
    self.action = ""
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
    x = self[from]
    y = self[to]
    dif = num > x ? x : num
    self[from] = x - dif
    self[to] = y + dif
  end

  def to_s
    [
      [:turn,"turn"],
      [:infantry,"兵士"],
      [:farmer,"農地"],
      [:food,"食料"],
      [:miner,"鉱山"],
      [:stone,"石材"],
      [:labo,"研究所"],
      [:science,"科学"],
      [:religion,"宗教"],
      [:worker,"労働者"],
      [:blue,"青"],
      [:yellow,"黄"]
    ].map do |attr,label|
      sprintf("%s:%2d ",label,send(attr))
    end.join(" ") + action
  end

  def dump
    if prev_state
      prev_state.dump
    else
      puts "-" * 103
    end
    puts to_s
  end

  def each(unit)
    case unit
    when :worker
      while create(unit)
        self.action += "+#{unit}"
      end
      yield clone
    else
      loop do
        yield clone
        break unless create(unit)
        self.action += "+#{unit}"
      end
    end
  end

  def create(unit)
    case unit
    when :worker
      if cost(:worker) <= food
        move(:food,:blue,cost(unit))
        move(:yellow,:worker,1)
      else
        false
      end

    else
      if stone >= cost(unit) && worker > 0
        move(:stone,:blue,cost(unit))
        move(:worker,unit,1)
      else
        false
      end
    end
  end

  def each_candidate
    state = clone.tap do |obj|
      obj.growth
    end
    state.each(:worker) do |state|
      state.each(:farmer) do |state|
        state.each(:miner) do |state|
          state.each(:labo) do |state|
            state.each(:infantry) do |state|
              state.each(:religion) do |state|
                if state.satisfy?
                  state.prev_state = self
                  yield state
                end
              end
            end
          end
        end
      end
    end
  end

  def satisfy?
    happy <= worker + religion
  end

  def prefer
    infantry + farmer + miner + labo
  end

end

class BFS
  def initialize(state)
    @queue = []
    @visited = []
    @anser = []
    @queue << state
    @visited << state
    @turn = 0
    @count = 0
  end

  def search
    while @anser.empty?
      break if @queue.empty?

      state = @queue.first
      if @turn < state.turn
        @queue.sort_by!{|o|-o.prefer}
        @queue = @queue.take(100)
        puts "turn:#{@turn} count:#{@count}"
        puts state
        STDOUT.flush
        @turn = state.turn
        @count = 0
      end
      @count += 1

      state = @queue.shift
      state.each_candidate do |state|
        next if @visited.include? state
        if yield state
          @anser << state
        else
          @visited << state
          @queue << state
        end
      end
    end

    @anser.each do |anser|
      anser.dump
    end
  end
end

state = State.new
bfs = BFS.new(state)
bfs.search do |state|
  state.infantry == 3 &&
  state.farmer == 3 &&
  state.miner == 3 &&
  state.labo == 3
end




