module CommandExecutor

  private

  #As per the CommandParser, in case of a real product, here could be
  #the place where to implement the Visitor pattern to use
  #the double-dispatch mechanism and travel the composite AST
  def execute_command(parsed_command)
    execution_method = "execute_#{parsed_command[:command]}".to_sym
    if self.respond_to? execution_method, true
      self.send execution_method, parsed_command[:params]
    else
      raise "Command '#{parsed_command[:command]}' not supported"
    end
  end

  def execute_place(place_command_data)
    dimensions_no = playground.dimensions_count
    if dimensions_no > place_command_data.size - 1
      raise "Playground dimensions=#{extension.size}, placement_array={place_command_data.size - 1}"
    end

    coordinates = place_command_data[0..place_command_data.size - 2].map{ |val| Integer(val) }

    (0..dimensions_no - 1).each do |idx|
      if coordinates[idx] > playground.max(idx)
        raise "Placing coordinates not valid: given=#{coordinates[idx]}, max_palyground=#{playground.max(idx)}"
      end
      if coordinates[idx] < playground.min(idx)
        raise "Placing coordinates not valid: given=#{coordinates[idx]}, min_palyground=#{playground.min(idx)}"
      end
    end

    self.position = ::RobotApp::Models::Position.new coordinates
    parsed_dir = parsed_direction_to_robot[place_command_data.last]
    raise "Direction #{place_command_data.last} not recognized" if parsed_dir.nil?
    self.direction = parsed_dir
  end

  def parsed_direction_to_robot
    {
      'NORTH' => self.class::Orientation_north,
      'SOUTH' => self.class::Orientation_south,
      'EAST' => self.class::Orientation_east,
      'WEST' => self.class::Orientation_west
    }
  end
end
