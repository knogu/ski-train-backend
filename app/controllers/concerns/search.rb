module Search
  def get_total_json(start_station, ski_resort)
    {
      "toSki": get_toski_json(start_station),
      "Back": get_back_json(start_station)
    }
  end

  def get_toski_json(start_station)
    json = []
    first_transport = Transport.find_by(start_station_id: Station.find_by(name: '海園の街').id, reach_station_id: Station.find_by(name: '東京').id)
    json.push(first_transport.json)
    second_transport = Transport.find_by(start_station_id: Station.find_by(name: '東京').id, reach_station_id: Station.find_by(name: '越後湯沢').id)
    json.push(second_transport.json(prev_transport_id = first_transport.id))
    third_transport = Transport.find_by(start_station_id: Station.find_by(name: '越後湯沢').id, reach_station_id: Station.find_by(name: '神立スノーリゾート').id)
    json.push(third_transport.json(prev_transport_id = second_transport.id))
    json
  end

  def get_back_json(start_station)
    json = []
    first_transport = Transport.find_by(start_station_id: Station.find_by(name: '神立スノーリゾート').id, reach_station_id: Station.find_by(name: '越後湯沢').id)
    json.push(first_transport.json())
    second_transport = Transport.find_by(start_station_id: Station.find_by(name: '越後湯沢').id, reach_station_id: Station.find_by(name: '東京').id)
    json.push(second_transport.json(prev_transport_id = first_transport.id))
    third_transport = Transport.find_by(start_station_id: Station.find_by(name: '東京').id, reach_station_id: Station.find_by(name: '海園の街').id)
    json.push(third_transport.json(prev_transport_id = second_transport.id))
    json
  end
end
