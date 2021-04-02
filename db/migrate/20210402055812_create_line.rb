class CreateLine < ActiveRecord::Migration[6.0]
  def change
    create_table :lines do |t|
      t.string :name
    end
  end
end
