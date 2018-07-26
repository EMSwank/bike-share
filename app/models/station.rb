class Station < ApplicationRecord

  validates_presence_of :name, :dock_count, :city, :installation_date

  has_many  :statuses
  has_many  :trips_started_at, class_name: 'Trip', foreign_key: :start_station_id, dependent: :delete_all
  has_many  :trips_ended_at, class_name: 'Trip', foreign_key: :end_station_id, dependent: :delete_all

  extend FriendlyId
  friendly_id :name, use: :slugged

  def self.total_count
    count
  end

  def self.average_bike_per_station
    average(:dock_count)
  end

  def self.most_bikes_at_station
    maximum(:dock_count)
  end

  def self.stations_name_most_bikes
    where(dock_count: most_bikes_at_station)
  end

  def self.fewest_bikes_at_station
    minimum(:dock_count)
  end

  def self.stations_name_fewest_bikes
    where(dock_count: fewest_bikes_at_station)
  end

  def self.newest_installation
    order('installation_date DESC').first.name
  end

  def self.oldest_installation
    order(:installation_date).first.name
  end

  def most_frequent_origin
    trips_ended_at.select("start_station_id, count(start_station_id) AS start_station_count")
                  .group("start_station_id")
                  .order("start_station_count DESC")
                  .limit(1).first.start_station
  end

  def most_frequent_destination
    trips_started_at.select("end_station_id, count(end_station_id) AS end_station_count")
                    .group("end_station_id")
                    .order("end_station_count DESC")
                    .limit(1).first.end_station
  end

  def most_popular_date
    trips_started_at.select("trips.start_date, count(start_date) AS date_count")
                    .group(:start_date, :id)
                    .order("date_count")
                    .limit(1).first.start_date
  end

end
