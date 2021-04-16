class Service < ApplicationRecord
  belongs_to :transport
  has_many :sercvice_date

  def json
    {
      startHour: start_hour,
      startMinute: start_minute,
      reachHour: reach_hour,
      reachMinute: reach_minute,
      isWithLaggageSpace: is_with_laggage_space
    }
  end

  def is_in_service(date)
    if is_depending_on_date
      ServiceDate.exists?(service_id: id, date: date)
    else
      (is_in_weekdays && date.on_weekday? && !HolidayJp.holiday?(date)) || (is_in_holidays && (date.on_weekend? || HolidayJp.holiday?(date)))
    end
  end
end
