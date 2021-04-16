class Transport < ApplicationRecord
  has_many :services
  validates :start_station_id, uniqueness: { scope: [:reach_station_id, :train_line_id] }

  def json(prev_transport_id = nil)
    if prev_transport_id.present?
      transfer = Transfer.find_by(station_id: start_station_id, train_line_1_id: [Transport.find(prev_transport_id).train_line_id, train_line_id].min, train_line_2_id: [Transport.find(prev_transport_id).train_line_id, train_line_id].max)
      transfer_hour, transfer_minute = transfer.default_hour, transfer.default_minute
    else
      transfer_hour, transfer_minute = 0, 0
    end
    {
      "transferHour": transfer_hour,
      "transferMinute": transfer_minute,
      "startStation": Station.find(start_station_id).name,
      "reachStation": Station.find(reach_station_id).name,
      "services": services.select(&:is_in_service).map(&:json)
    }
  end
end
