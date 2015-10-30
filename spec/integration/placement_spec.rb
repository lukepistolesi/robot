require_relative '../spec_helper'
require_relative '../../robot_app/application'

describe 'Placement within the grid', :integration do

  it 'places the robot within the grid' do
    commands = ['PLACE 1,0,WEST']

    output_lines = IntegrationHelper.run_application_with_commands commands

    expect(output_lines).to eql ['Output: 1,0,WEST']
  end

end