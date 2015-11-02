require_relative '../../../spec_helper'
require_relative '../../../../robot_app/models/concerns/command_executor'

module RobotApp::Models

  describe CommandExecutor do

    class RobotTestClass < Robot
      def initialize; end
    end

    let(:robot_test) { RobotTestClass.new }

    describe :execute_command do

      let(:parsed_command) { {command: :unsupported} }

      subject { robot_test.send :execute_command, parsed_command }

      it 'raises an exception when the command is not supported' do
        expect {subject}.to raise_error
      end

      it 'executes the place command' do
        parsed_command[:command] = :place
        parsed_command[:params] = []
        expect(robot_test).to receive(:execute_place).with parsed_command[:params]
        subject
      end

      it 'raises an exception when the sub execution raises an exception' do
        parsed_command[:command] = :place
        allow(robot_test).to receive(:execute_place).and_raise 'Sub-execution error'
        expect {subject}.to raise_error 'Sub-execution error'
      end
    end

    describe :execute_place do

      let(:extension) { [[1,3], [2,4]] }
      let(:playground) {
        instance_double Playground,
          dimensions_count: extension.size,
          max: extension.max { |a, b| a.last <=> b.last }.last,
          min: extension.min { |a, b| a.first <=> b.first }.first
      }
      let(:x_coordinate) { extension.first.first }
      let(:y_coordinate) { extension.last.first }
      let(:command_data) { [x_coordinate.to_s, y_coordinate.to_s, 'NORTH'] }

      before :each do
        allow(robot_test).to receive(:playground).and_return playground
        allow(Position).to receive :new
      end

      subject { robot_test.send :execute_place, command_data }

      it 'raises exception when the coordinates cardinality does not match the playground' do
        allow(playground).to receive(:dimensions_count).and_return extension.size + 1
        expect {subject}.to raise_error
      end

      it 'raises exception when the X coordinate is greater than the max X of playground' do
        allow(playground).to receive(:max).with(0).and_return x_coordinate - 1
        expect {subject}.to raise_error
      end

      it 'raises exception when the X coordinate is smaller than the min X of playground' do
        allow(playground).to receive(:min).with(0).and_return x_coordinate + 1
        expect {subject}.to raise_error
      end

      it 'raises exception when the Y coordinate is greater than the max Y of playground' do
        allow(playground).to receive(:max).with(1).and_return y_coordinate - 1
        expect {subject}.to raise_error
      end

      it 'raises exception when the Y coordinate is smaller than the min Y of playground' do
        allow(playground).to receive(:min).with(1).and_return y_coordinate + 1
        expect {subject}.to raise_error
      end

      it 'creates a new position with the given placement coordinates' do
        expect(Position).to receive(:new).with [x_coordinate, y_coordinate]
        subject
      end

      it 'assigns a new position to the robot' do
        new_pos = instance_double Position
        allow(Position).to receive(:new).and_return new_pos

        expect(robot_test).to receive(:position=).with new_pos

        subject
      end

      {
        'NORTH' => Robot::Orientation_north,
        'SOUTH' => Robot::Orientation_south,
        'EAST' => Robot::Orientation_east,
        'WEST' => Robot::Orientation_west
      }.each do |parsed_value, expected_value|
        it "assigns a new orientation to the robot for #{parsed_value}" do
          expect(robot_test).to receive(:direction=).with expected_value
          command_data[command_data.size - 1] = parsed_value
          subject
        end
      end

      it "raises exception when parsed direction is not supported" do
        command_data[command_data.size - 1] = 'Unsupported'
        expect {subject}.to raise_error
      end
    end


    describe :execute_move do

      describe 'safe move' do
        let(:extension) { [[0, 3], [0, 3]] }
        let(:safe_coordinates) { [1, 1] }
        let(:safe_position) { instance_double Position, coordinates: safe_coordinates }
        let(:playground) {
          instance_double Playground,
            max: extension.max { |a, b| a.last <=> b.last }.last,
            min: extension.min { |a, b| a.first <=> b.first }.first
        }

        before :each do
          allow(robot_test).to receive(:playground).and_return playground
          allow(robot_test).to receive(:position).and_return safe_position
        end

        it 'raises exception when the orientation is unsupported' do
          allow(robot_test).to receive(:direction).and_return :unknown
          expect {robot_test.send :execute_move, []}.to raise_error
        end

        [
          {update: :decremented, dimension_idx: 0, orientation: :west},
          {update: :incremented, dimension_idx: 0, orientation: :east},
          {update: :incremented, dimension_idx: 1, orientation: :north},
          {update: :decremented, dimension_idx: 1, orientation: :south}
        ].each do |move|

          let(:new_position) { instance_double Position }

          before :each do
            allow(robot_test).to receive(:direction).and_return move[:orientation]
            allow(Position).to receive(:new).and_return new_position
            allow(robot_test).to receive(:position_within_playground?).and_return true
            allow(robot_test).to receive :position=
          end

          it "creates #{move[:update]} dimension #{move[:dimension_idx]} because of orientation #{move[:orientation]}" do
            delta = move[:update] == :incremented ? 1 : -1
            new_coordinates = safe_coordinates.dup
            new_coordinates[move[:dimension_idx]] += delta
            allow(robot_test).to receive(:direction).and_return move[:orientation]

            expect(Position).to receive(:new).with new_coordinates

            robot_test.send :execute_move, []
          end

          it 'checks the newly created position against the playground' do
            expect(robot_test).to receive(:position_within_playground?).with new_position

            robot_test.send :execute_move, []
          end

          it 'updates the position within the robot' do
            expect(robot_test).to receive(:position=).with new_position
            robot_test.send :execute_move, []
          end
        end
      end

    end


    describe :execute_left do

      subject { robot_test.send :execute_left, [] }

      [
        {start: Robot::Orientation_north, stop: Robot::Orientation_west},
        {start: Robot::Orientation_west, stop: Robot::Orientation_south},
        {start: Robot::Orientation_south, stop: Robot::Orientation_east},
        {start: Robot::Orientation_east, stop: Robot::Orientation_north}
      ].each do |data|
        it "changes orientation from #{data[:start]} to #{data[:stop]}" do
          allow(robot_test).to receive(:direction).and_return data[:start]
          expect(robot_test).to receive(:direction=).with data[:stop]

          subject
        end
      end
    end

    describe :execute_right do

      subject { robot_test.send :execute_right, [] }

      [
        {start: Robot::Orientation_north, stop: Robot::Orientation_east},
        {start: Robot::Orientation_west, stop: Robot::Orientation_north},
        {start: Robot::Orientation_south, stop: Robot::Orientation_west},
        {start: Robot::Orientation_east, stop: Robot::Orientation_south}
      ].each do |data|
        it "changes orientation from #{data[:start]} to #{data[:stop]}" do
          allow(robot_test).to receive(:direction).and_return data[:start]
          expect(robot_test).to receive(:direction=).with data[:stop]

          subject
        end
      end
    end


    describe :position_within_playground? do

      let(:coordinates) { [3, 7] }
      let(:position) { instance_double Position, coordinates: coordinates }
      let(:playground) { instance_double Playground, dimensions_count: 2 }

      before :each do
        allow(robot_test).to receive(:playground).and_return playground
      end

      subject { robot_test.send :position_within_playground?, position }

      it 'checks the position coordinates against the playground' do
        expect(playground).to receive(:valid_value_for_dimension?).once.with(3, 0).and_return true
        expect(playground).to receive(:valid_value_for_dimension?).once.with(7, 1)

        subject
      end

      it 'returns true when all the coordinate are within the boundaries' do
        allow(playground).to receive(:valid_value_for_dimension?).and_return true

        expect(subject).to eql true
      end

      it 'returns false when when one ofhte values are outside the boundaries' do
        allow(playground).to receive(:valid_value_for_dimension?).and_return false

        expect(subject).to eql false
      end

      it 'returns false when the coordinates of the position are bigger than the playground' do
        coordinates << 5
        expect(subject).to eql false
      end

    end

  end
end
