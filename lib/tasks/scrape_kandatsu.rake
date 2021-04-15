require 'open-uri'

BUS_TIME = 12
def create_services_from_table(table, transport_id)
  table.search('tr').each do |tr_hour|
    th_hour = tr_hour.search('th')
    start_hour_str = th_hour.text.gsub(/[\r\n]/,"").strip
    if start_hour_str.blank?
      next
    end
    start_hour = start_hour_str.to_i
    tr_hour.search('td').each do |td_min|
      start_minute_str = td_min.text.gsub(/[\r\n]/,"").strip
      if start_minute_str.blank?
        next
      end
      start_minute = start_minute_str.to_i
      reach_minute = start_minute.to_i + BUS_TIME
      reach_hour = start_hour
      if reach_minute >= 60
        reach_minute -= 60
        reach_hour += 1
      end
      service = Service.find_or_create_by!(transport_id: transport_id, start_hour: start_hour, start_minute: start_minute, reach_hour: reach_hour, reach_minute: reach_minute, is_with_laggage_space: false, is_in_holidays: true, is_in_weekdays: true)
      p service
    end
  end
end

namespace :scrape_kandatsu do
  desc '越後湯沢←→神立スノーリゾート(2021春)'
  task :Echigoyuzawa2Kandatsu => :environment do
    page = Mechanize.new.get("https://www.kandatsu.com/2021spring/")
    div = page.search("//h3[contains(text(), '越後湯沢駅西口「KANDATSU BUS LOUNGE」直行')]/..")
    tables = div.search('table')
    table_to_Kandatsu, table_from_Kandatsu = tables[0], tables[1]

    echigoyuzawa_station_id = Station.find_or_create_by!(name: '越後湯沢').id
    kandatsu_station_id = Station.find_or_create_by!(name: '神立スノーリゾート').id
    train_line_id = TrainLine.find_or_create_by!(name: '神立スノーリゾート シャトルバス').id
    transport_to_kandatsu_id = Transport.find_or_create_by!(start_station_id: echigoyuzawa_station_id, reach_station_id: kandatsu_station_id, train_line_id: train_line_id).id
    transport_to_echigoyuzawa_id = Transport.find_or_create_by!(start_station_id: kandatsu_station_id, reach_station_id: echigoyuzawa_station_id, train_line_id: train_line_id).id

    create_services_from_table(table_to_Kandatsu, transport_to_kandatsu_id)
    create_services_from_table(table_to_Kandatsu, transport_to_echigoyuzawa_id)
  end
end
