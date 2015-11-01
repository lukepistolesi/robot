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

  end
end
