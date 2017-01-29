require "test/unit"

module YellowTokens
  def eat; [6,4,4,4,4,3,3,3,3,2,2,2,2,1,1,1,1,0,0][yellow]; end
  def cost; [nil,7,7,7,7,5,5,5,5,4,4,4,4,3,3,3,3,2,2][yellow]; end
  def happy; [8,7,7,6,6,5,5,4,4,3,3,2,2,2,2,1,1,0,0][yellow]; end
end

module BlueTokens
  def rotten; [6,4,4,4,4,4,2,2,2,2,2,0,0,0,0,0,0][blue]; end
end

class State < Struct.new(:infantry,:farmer,:food,:miner,:stone,:labo,:science,:religion,:worker,:blue,:yellow)
  include YellowTokens
  include BlueTokens
  attr_accessor :prev_state,:turn

  def initialize(prev_state=nil)
    if prev_state.kind_of? State
      super(*prev_state.values)
      @prev_state = prev_state
      @turn = prev_state.turn
    else
      super(1,2,0,2,0,1,0,0,1,16,18)
      @turn = 1
    end
  end

  def growth
    self.turn += 1
    self.science += labo
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
    end.join(" ")
  end

  def dump
    if prev_state
      prev_state.dump
    end
    puts to_s
  end

  def each_worker
    loop do
      break unless create_worker
    end
    yield clone
  end

  def create_worker
    if cost && food >= cost
      move(:food,:blue,cost)
      move(:yellow,:worker,1)
    else
      false
    end
  end

  def each_farmer
    loop do
      yield clone
      break unless create_farmer
    end
  end

  def create_farmer
    if stone >= 2 && worker > 0
      move(:stone,:blue,2)
      move(:worker,:farmer,1)
    else
      false
    end
  end

  def each_miner
    loop do
      yield clone
      break unless create_miner
    end
  end

  def create_miner
    if stone >= 2 && worker > 0
      move(:stone,:blue,2)
      move(:worker,:miner,1)
    else
      false
    end
  end

  def each_religion
    loop do
      yield clone
      break unless create_religion
    end
  end

  def create_religion
    if stone >= 3 && worker > 0
      move(:stone,:blue,3)
      move(:worker,:religion,1)
    else
      false
    end
  end

  def each_infantry
    loop do
      yield clone
      break unless create_infantry
    end
  end

  def create_infantry
    if stone >= 2 && worker > 0
      move(:stone,:blue,2)
      move(:worker,:infantry,1)
    else
      false
    end
  end

  def each_science
    loop do
      yield clone
      break unless create_science
    end
  end

  def create_science
    if stone >= 3 && worker > 0
      move(:stone,:blue,3)
      move(:worker,:labo,1)
    else
      false
    end
  end

  def each_candidate
    each_worker do |state|
      state.each_farmer do |state|
        state.each_miner do |state|
          state.each_science do |state|
            state.each_infantry do |state|
              state.each_religion do |state|
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

end

class BFS
  def initialize(state)
    @queue = []
    @visited = []
    @queue << state
    @visited << state
  end

  def search
    loop do
      if @queue.empty?
        puts "not found."
        return
      else
        state = @queue.shift
        if yield state
          puts "found."
          state.dump
          return
        else
          state.growth
          state.each_candidate do |state|
            unless @visited.include? state
              @visited << state
              @queue << state
            end
          end
        end
      end
    end
  end
end

state = State.new
bfs = BFS.new(state)
bfs.search do |state|
  state.science == 12 && state.infantry == 3
end






