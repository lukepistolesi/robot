require_relative '../../../spec_helper'
require_relative '../../../../robot_app/models/exceptions/placement_exception'

describe PlacementException do

  describe :initialize do
    it 'defines a message for the invalid direction' do
      exception = PlacementException.new 'My Direction'
      expect(exception.message).to eql 'Direction My Direction not recognized'
    end

    it 'defines a message for the invalid cardinality' do
      exception = PlacementException.new 1, 2
      expect(exception.message).to eql 'Invalid coordinates cardinality given=1, playground=2'
    end

    it 'defines a message for the invalid coordinates value' do
      exception = PlacementException.new 1, 2, 3
      expect(exception.message).to eql 'Placement coordinates not valid: given=1, limit_value=2, dimension_index=3'
    end

    it 'calls the parent initializer when unsupported numebr of params' do
      exception = PlacementException.new 1, 2, 3, 4
      expect(exception.message).to eql '[1, 2, 3, 4]'
    end
  end

end
