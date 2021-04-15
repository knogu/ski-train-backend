# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_04_15_102437) do

  create_table "service_dates", charset: "utf8mb4", force: :cascade do |t|
    t.integer "service_id", null: false
    t.date "date", null: false, comment: "serviceが運行している日付"
  end

  create_table "services", charset: "utf8", force: :cascade do |t|
    t.integer "transport_id", null: false, unsigned: true
    t.integer "start_hour", null: false, unsigned: true
    t.integer "start_minute", null: false, unsigned: true
    t.integer "reach_hour", null: false, unsigned: true
    t.integer "reach_minute", null: false, unsigned: true
    t.boolean "is_with_laggage_space", default: false
    t.string "platform", comment: "出発ホーム(番線)"
    t.boolean "is_depending_on_date", default: false, comment: "運行予定かどうかを、曜日ではなく日にちで判定するフラグ"
    t.boolean "is_in_weekdays", comment: "平日運行予定フラグ"
    t.boolean "is_in_holidays", comment: "土休日運行予定フラグ"
  end

  create_table "stations", charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_stations_on_name", unique: true
  end

  create_table "train_lines", charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_train_lines_on_name", unique: true
  end

  create_table "transfers", charset: "utf8", force: :cascade do |t|
    t.integer "station_id", null: false
    t.integer "train_line_1_id", null: false
    t.integer "train_line_2_id", null: false
    t.integer "default_hour", default: 0
    t.integer "default_minute", null: false
    t.index ["station_id", "train_line_1_id", "train_line_2_id"], name: "index_for_uniqueness", unique: true
  end

  create_table "transports", charset: "utf8", force: :cascade do |t|
    t.integer "start_station_id", null: false
    t.integer "reach_station_id", null: false
    t.integer "train_line_id", null: false
    t.index ["start_station_id", "reach_station_id", "train_line_id"], name: "index_for_uniqueness", unique: true
  end

end
