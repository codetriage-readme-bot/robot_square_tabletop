require './config/application'
require_relative 'table'
require_relative 'robot'

module Toy
  class Simulator
    attr_accessor :command

    def initialize
      @table = Toy::Table::Square.new
      @robot = Toy::Robot.new
      puts 'Hello, i am Toy Robot Simulator'
    end

    def execute(input)
      return if input.strip.empty?

      input = input.split(/\s+/)
      command = input.first
      args = input.last

      case command
      when truthy_command(command)
        send(command.downcase, args)
      else
        "#{Toy.config['system_messages']['invalid_command']} #{command}"
      end
    end

    private

    def truthy_command(command)
      Toy.config['commands'].include?(command) ? (self.command = command) : nil
    end

    def place(args)
      args = args.split(',')
      x = args[0].to_i
      y = args[1].to_i
      begin
        direction = args[2].downcase.to_sym
        raise unless @robot.orientation(direction) && @table.place(x, y)
        Toy.config['system_messages']['place_success']
      rescue
        Toy.config['system_messages']['invalid_arguments']
      end
    end

    def move(_args = nil)
      return Toy.config['system_messages']['place_failed'] unless @table.placed?
      position = @table.position
      step = @robot.step
      @table.place(position[:x] + step[:x], position[:y] + step[:y]) ? 'Movement implemented' : 'out of table'
    end

    def left(_args = nil)
      @robot.turn_left
    end

    def right(_args = nil)
      @robot.turn_right
    end

    def report(_args = nil)
      return Toy.config['system_messages']['place_failed'] unless @table.placed?
      position = @table.position
      direction = @robot.direction

      "#{position[:x]},#{position[:y]},#{direction.to_s.upcase}"
    end
  end
end
