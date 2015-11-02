require 'set'
require_relative '../lib/command_parser'
require_relative 'concerns/command_executor'

module RobotApp::Models

  class Robot
    include CommandExecutor

    attr_reader :playground
    attr_reader :direction

    Orientation_north = :north
    Orientation_south = :south
    Orientation_east = :east
    Orientation_west = :west
    ClockWiseOrientations = [Orientation_north, Orientation_east, Orientation_south, Orientation_west]
    Orientations = Set.new [Orientation_north, Orientation_south, Orientation_east, Orientation_west]

    def self.ori; 'abc' end

    def initialize
      @parser = RobotApp::CommandParser
    end

    def execute(command_string)
      parsed_command = parser.parse command_string
      execute_command parsed_command
    end

    def position
      Position.new @position.coordinates
    end


    def playground=(playground)
      raise 'Playground already assigned to this robot' unless @playground.nil?
      @playground = playground
    end

    private

    attr_reader :parser
    attr_writer :direction
    attr_writer :position

    def direction=(orientation)
      raise "Invalid orientation: #{orientation}" unless Orientations.include? orientation
      @direction = orientation
    end

  end
end
