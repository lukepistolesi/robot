require_relative '../../spec_helper'
require_relative '../../../robot_app/models/playground'

module RobotApp::Models

  describe Playground do

    describe :initialize do
      it 'copies the extensions' do
        given_extension = [[1, 2], [-1, 10]]
        stored_ext = Playground.new(given_extension).extension
        expected_ext = given_extension.dup
        given_extension.clear
        expect(stored_ext).to eql expected_ext
      end

      it 'raises exception when no list' do
        expect {Playground.new nil}.to raise_error
      end

      it 'raises exception when min value is bigger than max' do
        expect {Playground.new [[3, 1]]}.to raise_error
      end
    end

    describe :extension do
      it 'returns a copy of the extension' do
        given_extension = [[1, 2], [-1, 10]]
        playground = Playground.new given_extension

        playground.extension.clear

        expect(playground.extension).not_to be_empty
      end
    end

    describe :dimensions_count do
      it 'returns the number of dimensions of the playground' do
        dimensions = [[1, 3], [7, 10]]
        playground = Playground.new dimensions
        expect(playground.dimensions_count).to eql dimensions.size
      end
    end

    describe :min do
      it 'returns minimum coordinate value of a dimension' do
        dimensions = [[1, 3], [7, 10]]
        playground = Playground.new dimensions
        expect(playground.min 1).to eql dimensions.last.first
      end
    end

    describe :max do
      it 'returns maximum coordinate value of a dimension' do
        dimensions = [[1, 3], [7, 10]]
        playground = Playground.new dimensions
        expect(playground.max 0).to eql dimensions.first.last
      end
    end

    describe :valid_value_for_dimension? do
      it 'returns true when the value is wihtin the dimension' do
        dimensions = [[1, 3], [7, 10]]
        playground = Playground.new dimensions
        expect(playground.valid_value_for_dimension? 8, 1).to eql true
      end

      it 'returns false when the value is less than min value for the dimension' do
        dimensions = [[1, 3], [7, 10]]
        playground = Playground.new dimensions
        expect(playground.valid_value_for_dimension? 6, 1).to eql false
      end

      it 'returns false when the value is greater than max value for the dimension' do
        dimensions = [[1, 3], [7, 10]]
        playground = Playground.new dimensions
        expect(playground.valid_value_for_dimension? 4, 0).to eql false
      end

      it 'raises exception when invalid dimension' do
        dimensions = [[1, 3], [7, 10]]
        playground = Playground.new dimensions
        expect {playground.valid_value_for_dimension? 4, 2}.to raise_error
      end
    end

  end
end
