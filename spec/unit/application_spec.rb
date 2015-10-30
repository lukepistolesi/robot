require_relative '../spec_helper'
require_relative '../../robot_app/application'

module RobotApp

  describe Application do

    let(:cmd_line_args) { [] }

    describe :run do
      let(:parsed_opts) { {} }

      before :each do
        allow(Application).to receive(:parse_command_line_opts).and_return parsed_opts
        allow(Application).to receive(:gets).and_return nil
      end

      subject { Application.run cmd_line_args}

      it 'parses the command line options' do
        expect(Application).to receive(:parse_command_line_opts).with cmd_line_args
        subject
      end

      it 'waits for input from command line' do
        expect(Application).to receive(:gets).and_return nil
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
    end
  end
end
