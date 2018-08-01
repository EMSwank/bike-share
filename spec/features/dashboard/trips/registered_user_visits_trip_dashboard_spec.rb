require 'rails_helper'

describe 'A registered user' do
  before(:each) do
    @condition_1 = Condition.create!(date: DateTime.strptime('4/4/2016', '%m/%d/%Y'), max_temperature_f: 75, mean_temperature_f: 73, min_temperature_f: 71, mean_humidity: 45, mean_visibility_miles: 20, precipitation_inches: 3.0, mean_wind_speed_mph: 23.0, zip_code: 1223)
    @condition_2 = Condition.create!(date: DateTime.strptime('7/8/2017', '%m/%d/%Y'), max_temperature_f: 60, mean_temperature_f: 55, min_temperature_f: 57.5, mean_humidity: 40, mean_visibility_miles: 10, precipitation_inches: 2.0, mean_wind_speed_mph: 13.0, zip_code: 1224)
  end
  context 'visiting trips dashboard' do
    it 'sees the average duration of a ride' do
      user = create(:user)
      station = create(:station)
      trip = create(:trip, start_station: station, end_station: station, duration: 120)
      trip2 = create(:trip, start_station: station, end_station: station, duration: 60)
      trip3 = create(:trip, start_station: station, end_station: station, duration: 30)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit trips_dashboard_path
      expected_result = 70

      expect(page).to have_content("Average duration of a ride : #{expected_result}")
    end

    it 'sees the longest duration trip' do
      user = create(:user)
      station = create(:station)
      trip = create(:trip, start_station: station, end_station: station, duration: 120)
      trip2 = create(:trip, start_station: station, end_station: station, duration: 60)
      trip3 = create(:trip, start_station: station, end_station: station, duration: 30)

      visit trips_dashboard_path

      expected_result = trip

      expect(page).to have_link("#{expected_result.id}")
    end

    it 'sees the shortest duration trip' do
      user = create(:user)
      station = create(:station)
      trip = create(:trip, start_station: station, end_station: station, duration: 120)
      trip2 = create(:trip, start_station: station, end_station: station, duration: 60)
      trip3 = create(:trip, start_station: station, end_station: station, duration: 30)
      expected_result = trip3

      visit trips_dashboard_path

      expect(page).to have_content("#{expected_result.id}")
    end

    it 'sees the station with the most rides originating from it and the station with the most rides ending at it' do
      user = create(:user)
      station_1 = create(:station, name: 'Omlette')
      station_2 = create(:station, name: 'Fromage')
      trip = create(:trip, start_station: station_1, end_station: station_1, duration: 120)
      trip2 = create(:trip, start_station: station_1, end_station: station_2, duration: 60)
      trip3 = create(:trip, start_station: station_1, end_station: station_2, duration: 30)

      visit trips_dashboard_path

      expect(page).to have_content("Station with most trips originating:")
      expect(page).to have_content("Station with most trips ending:")
      expect(page).to have_link("#{station_1.name}")
      expect(page).to have_link("#{station_2.name}")
    end
    it 'sees a month by month breakdown of trips with a yearly subtotal' do
      user = create(:user)
      station_1 = create(:station, name: 'Omlette')
      station_2 = create(:station, name: 'Fromage')
      trip = create(:trip, start_date: DateTime.strptime('4/4/2016', '%m/%d/%Y'), start_station: station_1, end_station: station_2, duration: 120)
      trip2 = create(:trip, start_date: DateTime.strptime('4/5/2016', '%m/%d/%Y'), start_station: station_2, end_station: station_1, duration: 60)
      trip3 = create(:trip, start_date: DateTime.strptime('5/5/2016', '%m/%d/%Y'), start_station: station_2, end_station: station_1, duration: 30)
      trip4 = create(:trip, start_date: DateTime.strptime('5/6/2017', '%m/%d/%Y'), start_station: station_1, end_station: station_2, duration: 120)
      trip5 = create(:trip, start_date: DateTime.strptime('7/7/2017', '%m/%d/%Y'), start_station: station_2, end_station: station_1, duration: 60)
      trip6 = create(:trip, start_date: DateTime.strptime('7/8/2017', '%m/%d/%Y'), start_station: station_2, end_station: station_1, duration: 30)
      year_1 = '2016'
      year_2 = '2017'
      expected_number_1 = 2

      visit trips_dashboard_path

      expect(page).to have_content(year_1)
      expect(page).to have_content(year_2)
      expect(page).to have_content("Total trips for Apr 2016: #{expected_number_1}")
      expect(page).to have_content("Total trips for Jul 2017: #{expected_number_1}")
    end
    it 'shows most ridden bike with number of rides' do
      user = create(:user)
      station_1 = create(:station, name: 'Omlette')
      station_2 = create(:station, name: 'Fromage')
      trip = create(:trip, bike_id: 3, start_station: station_1, end_station: station_2)
      trip2 = create(:trip, bike_id: 3, start_station: station_1, end_station: station_2)
      trip3 = create(:trip, bike_id: 2, start_station: station_1, end_station: station_2)
      trip4 = create(:trip, bike_id: 3, start_station: station_1, end_station: station_2)
      trip5 = create(:trip, bike_id: 3, start_station: station_1, end_station: station_2)
      trip6 = create(:trip, bike_id: 2, start_station: station_1, end_station: station_2)
      special_bike = 3
      rides = 4

      visit trips_dashboard_path

      expect(page).to have_content("Most popular bike: Bike ##{special_bike}, with #{rides} number of rides")
    end
    it 'shows least ridden bike with number of rides' do
      user = create(:user)
      station_1 = create(:station, name: 'Omlette')
      station_2 = create(:station, name: 'Fromage')
      trip = create(:trip, bike_id: 3, start_station: station_1, end_station: station_2)
      trip2 = create(:trip, bike_id: 3, start_station: station_1, end_station: station_2)
      trip3 = create(:trip, bike_id: 2, start_station: station_1, end_station: station_2)
      trip4 = create(:trip, bike_id: 3, start_station: station_1, end_station: station_2)
      trip5 = create(:trip, bike_id: 3, start_station: station_1, end_station: station_2)
      trip6 = create(:trip, bike_id: 2, start_station: station_1, end_station: station_2)
      special_bike = 2
      rides = 2

      visit trips_dashboard_path

      expect(page).to have_content("Least ridden bike is Bike ##{special_bike}, with #{rides} number of rides")
    end
    it 'sees subscription type breakdown (with both count and percentage)' do
      user = create(:user)
      station_1 = create(:station, name: 'Omlette')
      station_2 = create(:station, name: 'Fromage')
      trip = create(:trip, subscription_type: "Admin Boi", start_station: station_1, end_station: station_2)
      trip2 = create(:trip, subscription_type: "Admin Boi", start_station: station_1, end_station: station_2)
      trip3 = create(:trip, subscription_type: "Admin Boi", start_station: station_1, end_station: station_2)
      trip4 = create(:trip, subscription_type: "Admin Boi", start_station: station_1, end_station: station_2)
      trip5 = create(:trip, subscription_type: "Slug Boi", start_station: station_1, end_station: station_2)
      trip6 = create(:trip, subscription_type: "Slug Boi", start_station: station_1, end_station: station_2)
      expected_admin_percent = 66.7
      expected_admin_count= 4
      expected_slug_percent = 33.3
      expected_slug_count = 2

      visit trips_dashboard_path

      expect(page).to have_content("#{expected_admin_count} total")
      expect(page).to have_content("Accounts for #{expected_admin_percent}% of all rides")
      expect(page).to have_content("#{expected_slug_count} total")
      expect(page).to have_content("Accounts for #{expected_slug_percent}% of all rides")
    end
    it 'sees date with highest number of trips' do
      user = create(:user)
      station_1 = create(:station, name: 'Omlette')
      station_2 = create(:station, name: 'Fromage')
      trip = create(:trip,  start_date: DateTime.strptime('4/4/2016', '%m/%d/%Y'), start_station: station_1, end_station: station_2)
      trip2 = create(:trip,  start_date: DateTime.strptime('4/4/2016', '%m/%d/%Y'), start_station: station_1, end_station: station_2)
      trip3 = create(:trip,  start_date: DateTime.strptime('4/4/2016', '%m/%d/%Y'), start_station: station_1, end_station: station_2)
      trip4 = create(:trip,  start_date: DateTime.strptime('5/6/2017', '%m/%d/%Y'), start_station: station_1, end_station: station_2)
      trip5 = create(:trip,  start_date: DateTime.strptime('2/7/2017', '%m/%d/%Y'), start_station: station_1, end_station: station_2)
      trip6 = create(:trip,  start_date: DateTime.strptime('7/8/2017', '%m/%d/%Y'), start_station: station_1, end_station: station_2)
      expected_result_1 = trip.start_date.strftime('%B, %d, %Y')
      expected_result_2 = 3

      visit trips_dashboard_path

      expect(page).to have_content("Date with most trips: #{expected_result_1}")
      expect(page).to have_content("Total number of trips: #{expected_result_2}")
    end
    it 'sees date with lowest number of trips' do
      user = create(:user)
      station_1 = create(:station, name: 'Omlette')
      station_2 = create(:station, name: 'Fromage')
      trip = create(:trip,  start_date: DateTime.strptime('4/4/2016', '%m/%d/%Y'), start_station: station_1, end_station: station_2)
      trip2 = create(:trip,  start_date: DateTime.strptime('4/4/2016', '%m/%d/%Y'), start_station: station_1, end_station: station_2)
      trip3 = create(:trip,  start_date: DateTime.strptime('4/4/2016', '%m/%d/%Y'), start_station: station_1, end_station: station_2)
      trip4 = create(:trip,  start_date: DateTime.strptime('5/6/2017', '%m/%d/%Y'), start_station: station_1, end_station: station_2)
      trip5 = create(:trip,  start_date: DateTime.strptime('5/6/2017', '%m/%d/%Y'), start_station: station_1, end_station: station_2)
      trip6 = create(:trip,  start_date: DateTime.strptime('7/8/2017', '%m/%d/%Y'), start_station: station_1, end_station: station_2)
      expected_result_1 = trip6.start_date.strftime('%B, %d, %Y')
      expected_result_2 = 1

      visit trips_dashboard_path

      expect(page).to have_content("Date with least trips: #{expected_result_1}")
      expect(page).to have_content("Total number of trips: #{expected_result_2}")
    end
    it 'sees the weather on the date with the highest number of trips' do
      user = create(:user)
      station_1 = create(:station, name: 'Omlette')
      station_2 = create(:station, name: 'Fromage')
      trip = create(:trip,  start_date: DateTime.strptime('4/4/2016', '%m/%d/%Y'), start_station: station_1, end_station: station_2)
      trip2 = create(:trip,  start_date: DateTime.strptime('4/4/2016', '%m/%d/%Y'), start_station: station_1, end_station: station_2)
      trip3 = create(:trip,  start_date: DateTime.strptime('4/4/2016', '%m/%d/%Y'), start_station: station_1, end_station: station_2)
      trip4 = create(:trip,  start_date: DateTime.strptime('5/6/2017', '%m/%d/%Y'), start_station: station_1, end_station: station_2)
      trip5 = create(:trip,  start_date: DateTime.strptime('5/6/2017', '%m/%d/%Y'), start_station: station_1, end_station: station_2)
      trip6 = create(:trip,  start_date: DateTime.strptime('7/8/2017', '%m/%d/%Y'), start_station: station_1, end_station: station_2)

      visit trips_dashboard_path

      expect(page).to have_content("Weather Conditions on the day with the most trips")
      expect(page).to have_content("#{@condition_1.max_temperature_f}")
      expect(page).to have_content("#{@condition_1.mean_temperature_f}")
      expect(page).to have_content("#{@condition_1.min_temperature_f}")
      expect(page).to have_content("#{@condition_1.mean_visibility_miles}")
      expect(page).to have_content("#{@condition_1.mean_wind_speed_mph}")
      expect(page).to have_content("#{@condition_1.mean_humidity}")
      expect(page).to have_content("#{@condition_1.precipitation_inches}")
      expect(page).to have_content("#{@condition_1.date.strftime("%B, %d, %Y")}")
    end
    it 'sees the weather on the date with the lowest number of trips' do
      user = create(:user)
      station_1 = create(:station, name: 'Omlette')
      station_2 = create(:station, name: 'Fromage')
      trip = create(:trip,  start_date: DateTime.strptime('4/4/2016', '%m/%d/%Y'), start_station: station_1, end_station: station_2)
      trip2 = create(:trip,  start_date: DateTime.strptime('4/4/2016', '%m/%d/%Y'), start_station: station_1, end_station: station_2)
      trip3 = create(:trip,  start_date: DateTime.strptime('4/4/2016', '%m/%d/%Y'), start_station: station_1, end_station: station_2)
      trip4 = create(:trip,  start_date: DateTime.strptime('5/6/2017', '%m/%d/%Y'), start_station: station_1, end_station: station_2)
      trip5 = create(:trip,  start_date: DateTime.strptime('5/6/2017', '%m/%d/%Y'), start_station: station_1, end_station: station_2)
      trip6 = create(:trip,  start_date: DateTime.strptime('7/8/2017', '%m/%d/%Y'), start_station: station_1, end_station: station_2)

      visit trips_dashboard_path

      expect(page).to have_content("Weather Conditions on the day with the least trips")
      expect(page).to have_content("Weather Conditions on the day with the most trips")
      expect(page).to have_content("#{@condition_2.max_temperature_f}")
      expect(page).to have_content("#{@condition_2.mean_temperature_f}")
      expect(page).to have_content("#{@condition_2.min_temperature_f}")
      expect(page).to have_content("#{@condition_2.mean_visibility_miles}")
      expect(page).to have_content("#{@condition_2.mean_wind_speed_mph}")
      expect(page).to have_content("#{@condition_2.mean_humidity}")
      expect(page).to have_content("#{@condition_2.precipitation_inches}")
      expect(page).to have_content("#{@condition_2.date.strftime("%B, %d, %Y")}")
    end
  end
end
