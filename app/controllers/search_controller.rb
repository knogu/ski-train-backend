class SearchController < ApplicationController
  include Search

  def index
    date = Date.new(params['year'].to_i, params['month'].to_i, params['date'].to_i)
    json = get_total_json(params['start_station'], params['ski_resort'], date)
    render json: json, status: :ok
  end
end
