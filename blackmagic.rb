class State < Struct.new(:x,:y)
  def eachx
    3.times.map{|n|State[x+n,y]}
  end

  def eachy
    3.times.map{|n|State[x,y+n]}
  end
end

state = State[10,20]

[state]
  .lazy
  .flat_map(&:eachx)
  .flat_map(&:eachy)
  .take(4)
  .each do |state|
    p state
  end

