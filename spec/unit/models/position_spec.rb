require_relative '../../spec_helper'
require_relative '../../../robot_app/models/position'

module RobotApp::Models

  describe Position do

    describe :initialize do
      it 'copies the coordinates' do
        given_coord = [1, 2]
        stored_coord = Position.new(given_coord).coordinates

        expected_coord = given_coord.dup
        given_coord.clear
        expect(stored_coord).to eql expected_coord
      end

      it 'defines accessors based on dimension character' do
        given_coord = [4, 7]
        position = Position.new given_coord
        first_letter = Position::Starting_letter_dimension
        expect(position).to respond_to first_letter.to_sym
        expect(position).to respond_to first_letter.next.to_sym
      end

      it 'defines accessors based on dimension character' do
        given_coord = [4, 7]
        position = Position.new given_coord
        first_letter = Position::Starting_letter_dimension
        expect(position.send first_letter.to_sym).to eql given_coord.first
        expect(position.send first_letter.next.to_sym).to eql given_coord.last
      end
    end

  end
end
