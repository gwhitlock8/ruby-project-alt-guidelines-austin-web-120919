# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_12_31_200833) do

  create_table "airports", force: :cascade do |t|
    t.string "name"
    t.string "region"
    t.string "city"
    t.string "icao_code"
  end

  create_table "flights", force: :cascade do |t|
    t.string "flight_number"
    t.string "departure_location"
    t.string "departure_date"
    t.string "departure_time"
    t.string "arrival_location"
    t.string "airline"
  end

  create_table "tickets", force: :cascade do |t|
    t.integer "flight_id"
    t.integer "user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password"
    t.string "hometown"
  end

end
