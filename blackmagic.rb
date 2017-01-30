class State < Struct.new(:x,:y)
  def fiber_x
    Fiber.new do
      Fiber.yield 
      10.times do |n|
        self.x = n
        Fiber.yield self
      end
    end
  end

  def fiber_y
    Fiber.new do
      10.times do |n|
        self.y = n
        Fiber.yield self
      end
    end
  end
end

