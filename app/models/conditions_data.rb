class ConditionsData
  attr_reader :trip_count_by_temp

  def initialize(trip_count_by_temp)
    @trip_count_by_temp = trip_count_by_temp
    @temp_breakdown = []
  end

  def all_possible_rides_by_temp
    temp_range = (40..99)
    temp_range.step(10).each do |temp|
      most_rides_in_temp_range(temp)
      least_rides_in_temp_range(temp)
      average_rides_in_temp_range(temp)
    end
  end

  def most_rides_in_temp_range(temp_range)
    by_degree = @trip_count_by_temp.select do |key, value|
      if key[1] >= temp_range.min && key[1] <= temp_range.max
          [key[0], value]
      else
        0
      end
    end
  end

  def least_rides_in_temp_range(temp)
  end
  def average_rides_in_temp_range(range)
  end
end
