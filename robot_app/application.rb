require 'optparse'

module RobotApp
end

Dir['./robot_app/**/*.rb'].each { |f| require f }

module RobotApp
  class Application

    MAX_X_GRID_IDX = MAX_Y_GRID_IDX = 4
    APPLICATION_COMMANDS = {
      report: 'REPORT'
    }

    def self.run(args)
      options = parse_command_line_opts args
      playground, robot = initialize_playground

      while input = gets
        input = input.strip.upcase
        if input == APPLICATION_COMMANDS[:report]
          report_position robot
        else
          robot.execute input
        end
      end
    end

    private

    def self.parse_command_line_opts(args)
      raise 'Wrong number of arguments' if args.size != 0
      {}
    end

    def self.initialize_playground
      #The order in the dimension array is the same of the PLACE command
      edge_x_length = [0, MAX_X_GRID_IDX]
      edge_y_length = [0, MAX_Y_GRID_IDX]
      playground = Models::Playground.new [edge_x_length, edge_y_length]
      robot = Models::Robot.new
      robot.playground = playground
      [playground, robot]
    end

    def self.report_position(robot)
      pos = robot.position
      puts [pos.x, pos.y, RobotApp::CommandParser::Orientations[robot.direction]].join(',')
    end
  end
end
