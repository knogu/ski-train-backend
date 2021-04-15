class CreateStation < ActiveRecord::Migration[6.0]
  def change
    create_table "stations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string :name, null: false
    end
    add_index :stations, :name, unique: true
  end
end
