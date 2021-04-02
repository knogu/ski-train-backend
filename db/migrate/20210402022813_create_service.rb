class CreateService < ActiveRecord::Migration[6.0]
  def change
    create_table "services", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer :transport_id, null: false, unsigned: true
      t.integer :start_hour, null: false, unsigned: true
      t.integer :start_minute, null: false, unsigned: true
      t.integer :reach_hour, null: false, unsigned: true
      t.integer :reach_minute, null: false, unsigned: true
      t.boolean :is_with_laggage_space, default: false
    end
  end
end
