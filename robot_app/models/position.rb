module RobotApp::Models

  class Position

    attr_reader :coordinates

    Starting_letter_dimension = 'x'

    def initialize(coordinates_list)
      @coordinates = coordinates_list.dup
      @dimension_to_value = {}

      dimension_letter = Starting_letter_dimension.dup

      coordinates_list.each do |value|
        dimension = dimension_letter.to_sym
        @dimension_to_value[dimension] = value

        self.class.send(:define_method, dimension.to_s) {
          @dimension_to_value[dimension]
        }
        dimension_letter.next!
      end
    end

  end
end
