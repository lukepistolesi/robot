module RobotApp::Models
  class Playground

    def initialize(dimension_extensions_list)
      dimension_extensions_list.find do |dim|
        raise "Min coordinate bigger than max: #{invalid}" if dim.first > dim.last
      end
      @extension = dimension_extensions_list.dup
    end

    def extension; @extension.dup end

    def dimensions_count; @extension.size end

    def min(idx); @extension[idx].first end

    def max(idx); @extension[idx].last end

  end
end
