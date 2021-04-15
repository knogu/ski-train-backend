class CreateTransport < ActiveRecord::Migration[6.0]
  def change
    create_table "transports", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer :start_station_id
      t.integer :reach_station_id
      t.integer :train_line_id
    end
    add_index :transports, [:start_station_id, :reach_station_id, :train_line_id], unique: true, name: 'index_for_uniqueness'
  end
end
