class Service < ApplicationRecord
  belongs_to :transfer

  def json
    {
      startHour: start_hour,
      startMinute: start_minute,
      reachHour: reach_hour,
      reachMinute: reach_minute,
      isWithLaggageSpace: is_with_laggage_space
    }
  end
end
