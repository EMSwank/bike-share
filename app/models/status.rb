class Status < ApplicationRecord
  validates_presence_of :station_id, :bikes_available, :docks_available, :time
end
