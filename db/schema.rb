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

ActiveRecord::Schema[7.2].define(version: 2026_05_24_101924) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "adventures", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "dungeon_id", null: false
    t.datetime "start_at", null: false
    t.datetime "end_at", null: false
    t.integer "status", default: 0, null: false
    t.integer "reward_gold", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dungeon_id"], name: "index_adventures_on_dungeon_id"
    t.index ["user_id"], name: "index_adventures_on_user_id"
  end

  create_table "dungeons", force: :cascade do |t|
    t.string "name", null: false
    t.integer "required_time", null: false, comment: "seconds"
    t.integer "difficulty", null: false
    t.integer "reward_gold", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "monsters", force: :cascade do |t|
    t.string "name", null: false
    t.integer "base_hp", null: false
    t.integer "base_atk", null: false
    t.integer "base_def", null: false
    t.integer "hire_cost", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "owned_monsters", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "monster_id", null: false
    t.string "nickname"
    t.integer "level", default: 1, null: false
    t.boolean "active", default: false, null: false
    t.integer "party_position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["monster_id"], name: "index_owned_monsters_on_monster_id"
    t.index ["user_id"], name: "index_owned_monsters_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.integer "gold", default: 100, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "adventures", "dungeons"
  add_foreign_key "adventures", "users"
  add_foreign_key "owned_monsters", "monsters"
  add_foreign_key "owned_monsters", "users"
end
