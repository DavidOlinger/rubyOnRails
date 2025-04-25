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

ActiveRecord::Schema[8.0].define(version: 2025_04_25_100423) do
  create_table "shared_schedules", force: :cascade do |t|
    t.string "share_token"
    t.string "username"
    t.string "schedule_name"
    t.text "schedule_content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["share_token"], name: "index_shared_schedules_on_share_token", unique: true
  end

  create_table "user_profiles", force: :cascade do |t|
    t.string "username"
    t.text "bio"
    t.string "profile_pic_url"
    t.string "favorite_spot"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["username"], name: "index_user_profiles_on_username", unique: true
  end
end
