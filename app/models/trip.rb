class Trip < ApplicationRecord
  validates_presence_of :bike_id, :subscription_type, :duration, :zip_code, :start_date, :end_date, :start_station_id, :end_station_id, :start_station_name, :end_station_name

  belongs_to :start_station, class_name: 'Station', foreign_key: :start_station_id
  belongs_to :end_station, class_name: 'Station', foreign_key: :end_station_id

  def self.average_duration_trip
    average(:duration)
  end

  def self.longest_ride
    order(duration: :desc).first
  end

  def self.shortest_ride
    order(duration: :desc).last
  end

  def self.station_with_most_rides_originating
   desired_station = select("start_station_id, COUNT(start_station_id) AS trips")
   .group("start_station_id")
   .order("trips DESC").limit(1)
   Station.find(desired_station.first.start_station_id)
  end

  def self.station_with_most_rides_ending
   desired_station = select("end_station_id, COUNT(end_station_id) AS trips")
   .group("end_station_id")
   .order("trips DESC").limit(1)
   Station.find(desired_station.first.end_station_id)
  end

  def self.year_by_year
    Trip.group("date_trunc('month', start_date)").count
  end

  def month_by_month(year)
    Trip.select(:start_date).where(year: year)
  end
end
