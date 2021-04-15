class CreateServiceDates < ActiveRecord::Migration[6.1]
  def change
    create_table :service_dates do |t|
      t.integer :service_id
      t.date :date, comment: 'serviceが運行している日付'

      t.timestamps
    end
  end
end
