class AddColumnsToService < ActiveRecord::Migration[6.1]
  def change
    add_column :services, :is_depending_on_date, :boolean, default: false, comment: "運行予定かどうかを、曜日ではなく日にちで判定するフラグ"
    add_column :services, :is_in_weekdays, :boolean, comment: '平日運行予定フラグ'
    add_column :services, :is_in_holidays, :boolean, comment: '土休日運行予定フラグ'
  end
end
