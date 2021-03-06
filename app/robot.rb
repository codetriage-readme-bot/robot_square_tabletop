module Toy
  class Robot
    attr_accessor :direction

    def orientation(direction)
      self.direction = direction if Toy.config['facing'].find { |face| face.downcase.to_sym == direction }
    end

    def turn_left
      self.direction = { north: :west, west: :south, south: :east, east: :north }[direction]
    end

    def turn_right
      self.direction = { north: :east, west: :north, south: :west, east: :south }[direction]
    end

    def step
      step = Toy.config['step'].to_i
      case direction
      when :north
        { x: 0, y: step }
      when :south
        { x: 0, y: -step }
      when :west
        { x: -step, y: 0 }
      when :east
        { x: step, y: 0 }
      else
        raise SYSTEM_MESSAGES['unknown_direction']
      end
    end
  end
end
