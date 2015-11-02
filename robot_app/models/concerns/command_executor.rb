require_relative '../exceptions/placement_exception'

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
      raise PlacementException.new(dimensions_no, place_command_data.size - 1)
    end

    coordinates = place_command_data[0..place_command_data.size - 2].map{ |val| Integer(val) }

    (0..dimensions_no - 1).each do |idx|
      if coordinates[idx] > playground.max(idx)
        raise PlacementException.new(coordinates[idx], playground.max(idx), idx)
      end
      if coordinates[idx] < playground.min(idx)
        raise PlacementException.new(coordinates[idx], playground.min(idx), idx)
      end
    end

    self.position = RobotApp::Models::Position.new coordinates

    parsed_dir = parsed_direction_to_robot[place_command_data.last]
    raise PlacementException.new(place_command_data.last) if parsed_dir.nil?
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

  def execute_move(move_command_data)
    new_coordinates = self.position.coordinates

    case self.direction
      when self.class::Orientation_north
        new_coordinates[1] += 1
      when self.class::Orientation_south
        new_coordinates[1] -= 1
      when self.class::Orientation_east
        new_coordinates[0] -= 1
      when self.class::Orientation_west
        new_coordinates[0] += 1
      else
        raise "Orientation unknown #{self.direction}"
    end

    new_position = RobotApp::Models::Position.new new_coordinates
    self.position = new_position if position_within_playground? new_position
  end

  def execute_left(left_command_data)
    clock_wise = [
      self.class::Orientation_north,
      self.class::Orientation_east,
      self.class::Orientation_south,
      self.class::Orientation_west
    ]
    idx = clock_wise.index(self.direction) - 1
    new_direction_idx = idx < 0 ? clock_wise.size - 1 : idx
    self.direction = clock_wise[new_direction_idx]
  end


  def position_within_playground?(position)
    coordinates = position.coordinates
    return false if coordinates.size > playground.dimensions_count
    coordinates.each_with_index do |value, idx|
      return false unless self.playground.valid_value_for_dimension? value, idx
    end
    true
  end

end
