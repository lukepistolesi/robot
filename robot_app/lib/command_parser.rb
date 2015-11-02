module RobotApp
  #This class is quite simple but it could become the starting point
  #for a real parser for a type 2 language with its own AST
  class CommandParser

    Orientations = {
      north: 'NORTH',
      south: 'SOUTH',
      west: 'WEST',
      east: 'EAST'
    }

    Commands = {
      place: Regexp.new("^PLACE (\\d+),(\\d+),(#{Orientations.values.join '|'})$"),
      move: /^MOVE$/,
      left: /^LEFT$/,
      right: /^RIGHT$/
    }

    def self.parse(command_string)
      matching_command = nil

      Commands.each do |command_key, regex|
        matches = regex.match command_string
        next if matches.nil?
        matching_command = {command: command_key, params: matches[1..matches.size]}
        break
      end

      matching_command.nil? ? raise("Command not valid: #{command_string}") : matching_command
    end
  end
end
