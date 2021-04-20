require 'open-uri'

YEAR = 2021
# pageには便の運行予定表のページのMecanizeオブジェクトを与える ex)https://www.jreast-timetable.jp/2104/train/050/053571.html
def dates_service_is_on(page)
  dates = []
  page.search('table.calendar-month').each do |month_table|
    month = /.*年(.*)月/.match(month_table.search('caption').text)[1].to_i
    month_table.search('td.ok').each do |td|
      date = td.search('span').text.gsub(/[\r\n]/,"").to_i
      dates << Date.new(YEAR, month, date)
    end
  end
  dates
end

def retrieve_start_station_data(service_page, start_station_name)
  service_page.search('tr.time').each do |time_row|
    station_name = time_row.search('th.time').text.gsub(/[\r\n]/,"")
    if station_name == start_station_name
      platform = time_row.search('.platform').search('.time_normal').text.gsub(/[\r\n]/,"")
      start_time_text = time_row.search('td.time').search('.time_normal').text
      start_hour, start_minute = /(.*):(.*) 発/.match(start_time_text).values_at(1,2)
      return {name: start_station_name, platform: platform, start_hour: start_hour, start_minute: start_minute}
    end
  end
end

def retrieve_start_station_data_array(service_page, start_station_array)
  station_data_array = []
  start_station_array.each do |start_station|
    station_data_array << retrieve_start_station_data(service_page, start_station)
  end
  station_data_array
end

def retrieve_reach_station_data(service_page, reach_station_name)
  service_page.search('tr.time').each do |time_row|
    station_name = time_row.search('th.time').text.gsub(/[\r\n]/,"")
    if station_name == reach_station_name
      reach_time_text = time_row.search('td.time').search('.time_normal').text
      reach_hour, reach_minute = /(.*):(.*) 着/.match(reach_time_text).values_at(1,2)
      return {name: reach_station_name, reach_hour: reach_hour, reach_minute: reach_minute}
    end
  end
  return
end

def retrieve_reach_station_data_array(service_page, reach_station_array)
  station_data_array = []
  reach_station_array.each do |reach_station|
    reach_station_data = retrieve_reach_station_data(service_page, reach_station)
    station_data_array << reach_station_data if reach_station_data.present?
  end
  station_data_array
end

def has_laggage_space(page)
  # Maxたにがわ、Maxとき以外は荷物置き場がある
  page.search('.line_name').text.include?('Ｍａｘ')
end

def seed_services(train_line_id, start_station_array, reach_station_array, url_for_timetable_at_start_station)
  page = Mechanize.new.get(url_for_timetable_at_start_station)
  p 'service count:', (page.links_with(:class => 'time_link_red') + page.links_with(:class => 'time_link_black')).count
  (page.links_with(:class => 'time_link_red') + page.links_with(:class => 'time_link_black')).each do |link|
    service_page = link.click
    laggage_space = has_laggage_space(service_page)
    dates = dates_service_is_on(service_page)
    start_station_data_array = retrieve_start_station_data_array(service_page, start_station_array)
    reach_station_data_array = retrieve_reach_station_data_array(service_page, reach_station_array)
    
    start_station_data_array.each do |start_station_data|
      start_station_id = Station.find_or_create_by!(name: start_station_data[:name]).id
      reach_station_data_array.each do |reach_station_data|
        reach_station_id = Station.find_or_create_by!(name: reach_station_data[:name]).id
        transport_id = Transport.find_or_create_by!(start_station_id: start_station_id, reach_station_id: reach_station_id, train_line_id: train_line_id).id
        service = Service.find_or_create_by!(transport_id: transport_id, start_hour: start_station_data[:start_hour], start_minute: start_station_data[:start_minute], reach_hour: reach_station_data[:reach_hour], reach_minute: reach_station_data[:reach_minute], is_with_laggage_space: laggage_space, platform: start_station_data[:platform], is_depending_on_date: true)
        p 'created service: ', service
        p 'service_date count:', dates.count
        dates.each do |date|
          ServiceDate.find_or_create_by!(service_id: service.id, date:date)
        end
      end
    end
    sleep 1.5
  end
end

stations_in_Tokyo = ['東京']
stations_nearby_ski_resort = ['越後湯沢']
namespace :scrape_joetsu_shinkansen do
  desc '平日、東京から越後湯沢'
  task :weekday_from_Tokyo => :environment do
    train_line_id = TrainLine.find_or_create_by!(name: '上越新幹線').id
    seed_services(train_line_id = train_line_id, start_station_array = stations_in_Tokyo, reach_station_name = stations_nearby_ski_resort, url_for_timetable_at_start_station =  'https://www.jreast-timetable.jp/2105/timetable/tt1039/1039050.html')
  end

  desc '土休日、東京から越後湯沢'
  task :holiday_from_Tokyo => :environment do
    train_line_id = TrainLine.find_or_create_by!(name: '上越新幹線').id
    seed_services(train_line_id = train_line_id, start_station_array = stations_in_Tokyo, reach_station_name = stations_nearby_ski_resort, url_for_timetable_at_start_station =  'https://www.jreast-timetable.jp/2105/timetable/tt1039/1039051.html')
  end

  desc '平日、越後湯沢から東京'
  task :weekday_from_Echigoyuzawa => :environment do
    train_line_id = TrainLine.find_or_create_by!(name: '上越新幹線').id
    seed_services(train_line_id = train_line_id, start_station_array = stations_nearby_ski_resort, reach_station_name = stations_in_Tokyo, url_for_timetable_at_start_station =  'https://www.jreast-timetable.jp/2105/timetable/tt0285/0285030.html')
  end

  desc '休日、越後湯沢から東京'
  task :holiday_from_Echigoyuzawa => :environment do
    train_line_id = TrainLine.find_or_create_by!(name: '上越新幹線').id
    seed_services(train_line_id = train_line_id, start_station_array = stations_nearby_ski_resort, reach_station_name = stations_in_Tokyo, url_for_timetable_at_start_station =  'https://www.jreast-timetable.jp/2105/timetable/tt0285/0285031.html')
  end
end
