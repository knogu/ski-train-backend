class CreateLine < ActiveRecord::Migration[6.0]
  def change
    create_table "train_lines", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string :name, null: false
    end
    add_index :train_lines, :name, unique: true
  end
end
