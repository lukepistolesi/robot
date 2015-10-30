require 'optparse'
Dir['./robot_app/**/*.rb'].each { |f| require f }

module RobotApp
  class Application
    def self.run(args)
      options = parse_command_line_opts args
      #Just a simple placeholder for the time being
      while input = gets
      end
    end

    def self.parse_command_line_opts(args)
      raise 'Wrong number of arguments' if args.size != 0
    end
  end
end
