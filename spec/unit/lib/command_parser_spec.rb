require_relative '../../spec_helper'
require_relative '../../../robot_app/lib/command_parser'

module RobotApp

  describe CommandParser do
    it 'raises exception when no matching' do
      expect {CommandParser.parse 'Invalid command'}.to raise_error
    end

    it 'returns the parsed object for the PLACE command' do
      x, y, direction = '5', '7', 'NORTH'
      res = CommandParser.parse "PLACE #{x},#{y},#{direction}"
      expect(res).to eql({
        command: :place,
        params: [x, y, direction]
      })
    end

    it 'returns the parsed object for the MOVE command' do
      res = CommandParser.parse 'MOVE'
      expect(res).to eql( {command: :move, params: []} )
    end

    it 'returns the parsed object for the LEFT command' do
      res = CommandParser.parse 'LEFT'
      expect(res).to eql( {command: :left, params: []} )
    end
  end

end
