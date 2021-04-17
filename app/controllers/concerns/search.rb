module Search
  def get_total_json(start_station, ski_resort, date)
    {
      "toSki": get_toski_json(start_station, ski_resort, date),
      "Back": get_back_json(start_station, ski_resort, date)
    }
  end

  def get_toski_json(start_station, ski_resort, date)
    json = []
    first_transport = Transport.find_by(start_station_id: Station.find_by(name: start_station).id, reach_station_id: Station.find_by(name: '東京').id)
    json.push(first_transport.json(date))
    second_transport = Transport.find_by(start_station_id: Station.find_by(name: '東京').id, reach_station_id: Station.find_by(name: '越後湯沢').id)
    json.push(second_transport.json(date, prev_transport_id = first_transport.id))
    third_transport = Transport.find_by(start_station_id: Station.find_by(name: '越後湯沢').id, reach_station_id: Station.find_by(name: ski_resort).id)
    json.push(third_transport.json(date, prev_transport_id = second_transport.id))
    json
  end

  def get_back_json(start_station, ski_resort, date)
    json = []
    first_transport = Transport.find_by(start_station_id: Station.find_by(name: ski_resort).id, reach_station_id: Station.find_by(name: '越後湯沢').id)
    json.push(first_transport.json(date))
    second_transport = Transport.find_by(start_station_id: Station.find_by(name: '越後湯沢').id, reach_station_id: Station.find_by(name: '東京').id)
    json.push(second_transport.json(date, prev_transport_id = first_transport.id))
    third_transport = Transport.find_by(start_station_id: Station.find_by(name: '東京').id, reach_station_id: Station.find_by(name: start_station).id)
    json.push(third_transport.json(date, prev_transport_id = second_transport.id))
    json
  end
end
