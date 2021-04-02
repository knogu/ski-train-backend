class CreateStation < ActiveRecord::Migration[6.0]
  def change
    create_table :stations do |t|
      t.string :name, null: false
    end
  end
end
