class CreateTransport < ActiveRecord::Migration[6.0]
  def change
    create_table "transports", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer :start_station_id
      t.integer :reach_station_id
      t.integer :train_line_id
    end
  end
end
