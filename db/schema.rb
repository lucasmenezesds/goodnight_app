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

ActiveRecord::Schema.define(version: 2023_06_14_151336) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "relationships", force: :cascade do |t|
    t.uuid "source_id", null: false
    t.uuid "target_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["deleted_at"], name: "index_relationships_on_deleted_at"
    t.index ["source_id", "target_id"], name: "index_relationships_on_source_id_and_target_id", unique: true
    t.index ["source_id"], name: "index_relationships_on_source_id"
    t.index ["target_id"], name: "index_relationships_on_target_id"
  end

  create_table "sleep_logs", force: :cascade do |t|
    t.uuid "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "woke_up_at", precision: 6
    t.time "duration"
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.index ["created_at"], name: "index_sleep_logs_on_created_at"
    t.index ["user_id", "created_at"], name: "index_sleep_logs_on_user_id_and_created_at_by_desc_order", order: { created_at: :desc }
    t.index ["user_id", "duration"], name: "index_sleep_logs_on_user_id_and_duration_by_desc_order", order: { duration: :desc }
    t.index ["user_id"], name: "index_sleep_logs_on_user_id"
    t.index ["uuid"], name: "index_sleep_logs_on_uuid", unique: true
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
  end

  add_foreign_key "relationships", "users", column: "source_id"
  add_foreign_key "relationships", "users", column: "target_id"
  add_foreign_key "sleep_logs", "users"
end
