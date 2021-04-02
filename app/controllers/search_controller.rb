class SearchController < ApplicationController
  include Search

  def index
    json = get_total_json(params['start_station'], params['ski_resort'])
    # json = {"これは": "returnです"}
    render json: json, status: :ok
  end
end
