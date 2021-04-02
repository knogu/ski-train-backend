class CreateTransfer < ActiveRecord::Migration[6.0]
  def change
    create_table :transfers do |t|
      t.integer :station_id, null: false
      t.integer :line_1_id, null: false
      t.integer :line_2_id, null: false
      t.integer :default_hour, default: 0
      t.integer :default_minute, null: false
    end
  end
end
