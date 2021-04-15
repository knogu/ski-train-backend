class CreateServiceDates < ActiveRecord::Migration[6.1]
  def change
    create_table :service_dates do |t|
      t.integer :service_id, null: false
      t.date :date, null: false, comment: 'serviceが運行している日付'
    end
  end
end
