class CreateTransport < ActiveRecord::Migration[6.0]
  def change
    create_table :transports do |t|
      t.integer :start_station_id
      t.integer :reach_station_id
      t.integer :line_id
    end
  end
end
