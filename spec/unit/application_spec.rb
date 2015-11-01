require_relative '../spec_helper'
require_relative '../../robot_app/application'
require_relative '../../robot_app/models/exceptions/placement_exception'

module RobotApp

  describe Application do

    let(:cmd_line_args) { [] }

    describe :run do
      let(:robot) { instance_double Models::Robot }
      let(:playground) { instance_double Models::Playground }

      before :each do
        allow(Application).to receive(:parse_command_line_opts).and_return({})
        allow(Application).to receive(:initialize_playground).and_return [playground, robot]
        allow(Application).to receive(:gets).and_return nil
        allow(Application).to receive :puts
      end

      subject { Application.run cmd_line_args}

      it 'parses the command line options' do
        expect(Application).to receive(:parse_command_line_opts).with cmd_line_args
        subject
      end

      it 'initializes the playground area' do
        expect(Application).to receive :initialize_playground
        subject
      end

      it 'waits for input from command line' do
        expect(Application).to receive(:gets).and_return nil
        subject
      end

      it 'passes the commands to the robot' do
        command = 'An Action'
        allow(Application).to receive(:gets).and_return command, nil

        expect(robot).to receive(:execute).with command.upcase

        subject
      end

      it 'handles execution exceptions' do
        command = 'An Action'
        allow(Application).to receive(:gets).and_return command, nil
        exception = Exception.new 'Some sort of exception'
        allow(robot).to receive(:execute).and_raise exception

        expect(Application).to receive(:handle_execution_exception).with exception

        subject
      end

      it 'prints out the robot position when requested' do
        command = Application::APPLICATION_COMMANDS[:report]
        allow(Application).to receive(:gets).and_return command, nil

        expect(Application).to receive(:report_position).with robot

        subject
      end

      it 'does not execute the command when application command' do
        command = Application::APPLICATION_COMMANDS[:report]
        allow(Application).to receive(:gets).and_return command, nil
        allow(Application).to receive :report_position

        expect(robot).not_to receive :execute

        subject
      end
    end


    describe :parse_command_line_opts do

      subject { Application.parse_command_line_opts cmd_line_args}

      it 'raises exception when command line params' do
        expected_file_name = 'Input File Name'
        cmd_line_args << expected_file_name
        expect{subject}.to raise_error 'Wrong number of arguments'
      end

      it 'returns empty hash' do
        expect(subject).to eql({})
      end
    end


    describe :initialize_playground do

      let(:robot) { instance_double Models::Robot, :playground= => nil }
      let(:playground) { instance_double Models::Playground }

      before :each do
        allow(Models::Playground).to receive(:new).and_return playground
        allow(Models::Robot).to receive(:new).and_return robot
      end

      subject { Application.initialize_playground }

      it 'creates a new playground' do
        dimensions = [[0,4], [0,4]]
        expect(Models::Playground).to receive(:new).with dimensions
        subject
      end

      it 'creates a robot' do
        expect(Models::Robot).to receive(:new).and_return robot
        subject
      end

      it 'assigns the playground to the robot' do
        expect(robot).to receive(:playground=).with playground
        subject
      end

      it 'returns the created playground and robot' do
        expect(subject).to eql [playground, robot]
      end
    end

    describe :report_position do
      let(:position) { double(Models::Position).as_null_object }
      let(:direction) { RobotApp::CommandParser::Orientations.keys.first }
      let(:robot) { instance_double Models::Robot, position: position, direction: direction }

      before :each do
        allow(Application).to receive :puts
      end

      subject { Application.report_position robot }

      it 'retrieves the robot position' do
        expect(robot).to receive(:position).and_return position
        subject
      end

      it 'prints the robot position and direction' do
        x, y, dir = [12, 15, RobotApp::CommandParser::Orientations[direction]]
        allow(position).to receive(:x).and_return x
        allow(position).to receive(:y).and_return y
        allow(robot).to receive(:direction).and_return direction

        expect(Application).to receive(:puts).with "#{x},#{y},#{dir}"

        subject
      end
    end

    describe :handle_execution_exception do
      it 'prints the exception message when robot placement exception' do
        exception = instance_double PlacementException, message: 'Placement ex'

        expect(Application).to receive(:puts).with 'Placement ex'

        Application.send :handle_execution_exception, exception
      end

      it 'raises exception when general exception' do
        exception = Exception.new
        expect {Application.send :handle_execution_exception, exception}.to raise_error exception
      end

      it 'raises exception when standard error' do
        exception = StandardError.new
        expect {Application.send :handle_execution_exception, exception}.to raise_error exception
      end

      it 'raises exception when runtime error' do
        exception = RuntimeError.new
        expect {Application.send :handle_execution_exception, exception}.to raise_error exception
      end
    end

  end
end
