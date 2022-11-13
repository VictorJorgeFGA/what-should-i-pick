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

ActiveRecord::Schema[7.0].define(version: 2022_11_12_222712) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "champions", force: :cascade do |t|
    t.string "name"
    t.integer "key"
    t.string "title"
    t.string "image_full"
    t.string "image_sprite"
    t.text "lore"
    t.text "blurb"
    t.integer "hp"
    t.integer "move_speed"
    t.integer "armor"
    t.integer "attack_range"
    t.integer "attack_damage"
    t.float "crit"
    t.integer "attack"
    t.integer "defense"
    t.integer "magic"
    t.integer "difficulty"
    t.string "primary_role"
    t.string "secondary_role"
    t.text "enemy_tips"
    t.text "ally_tips"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_champions_on_key", unique: true
  end

end
