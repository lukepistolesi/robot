class PlacementException < Exception

  def initialize(*args)
    case args.size
      when 1
        super "Direction #{args.first} not recognized"
      when 2
        super "Invalid coordinates cardinality given=#{args.first}, playground=#{args.last}"
      when 3
        super "Placement coordinates not valid: given=#{args[0]}, limit_value=#{args[1]}, dimension_index=#{args[2]}"
      else
        super args
    end
  end
end
