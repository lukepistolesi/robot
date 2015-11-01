require_relative '../../spec_helper'
require_relative '../../../robot_app/models/robot'
require_relative '../../../robot_app/models/position'
require_relative '../../../robot_app/models/playground'

module RobotApp::Models

  describe Robot do
    describe :initialize do

      before :each do
        allow(RobotApp::CommandParser).to receive :new
      end

      subject { Robot.new }

      it 'uses the static parser' do
        expect(subject.send :parser).to eql RobotApp::CommandParser
      end

      it 'sets no playground' do
        expect(subject.playground).to be_nil
      end
    end

    describe :execute do

      let(:parser) { RobotApp::CommandParser }
      let(:robot) { Robot.new }

      before :each do
        allow(robot).to receive(:parser).and_return parser
        allow(robot).to receive :execute_command
      end

      subject { lambda { |command| robot.execute command } }

      it 'parses the command string' do
        command = 'An Action'
        expect(parser).to receive(:parse).with command

        subject.call command
      end

      it 'executes the parsed command' do
        parsed_command = 'PArsed'
        allow(parser).to receive(:parse).and_return parsed_command

        expect(robot).to receive(:execute_command).with parsed_command

        subject.call 'A Command'
      end
    end


    describe :position do

      let(:coordinates) { {} }
      let(:position) { instance_double Position, coordinates: coordinates }
      let(:robot) { Robot.new }

      before :each do
        allow(RobotApp::CommandParser).to receive(:new).and_return null_object
      end

      subject { robot.position }

      it 'creates a copy of the position' do
        robot.instance_variable_set :@position, position

        expect(Position).to receive(:new).with coordinates

        subject
      end

      it 'returns the copy of the position' do
        robot.instance_variable_set :@position, position
        new_position = instance_double Position

        allow(Position).to receive(:new).and_return new_position

        expect(subject).to eql new_position
      end
    end

    describe :playground= do
      let(:playground) { instance_double Playground }

      before :each do
        allow(RobotApp::CommandParser).to receive :new
      end

      it 'assigns the playground instance' do
        robot = Robot.new
        robot.playground = playground

        expect(robot.playground).to eql playground
      end

      it 'raises exception when the playground is already assigned' do
        robot = Robot.new
        robot.playground = playground

        expect {robot.playground = playground}.to raise_error
      end
    end
  end
end
