class CreateLine < ActiveRecord::Migration[6.0]
  def change
    create_table "lines", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string :name
    end
  end
end
