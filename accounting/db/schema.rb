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

ActiveRecord::Schema[7.0].define(version: 2023_08_26_092141) do
  create_table "accounts", force: :cascade do |t|
    t.string "public_id"
    t.string "full_name"
    t.integer "role"
    t.string "email"
    t.string "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "balance", default: 0, null: false
  end

  create_table "audit_logs", force: :cascade do |t|
    t.integer "balance", default: 0, null: false
    t.integer "transaction"
    t.string "description"
    t.integer "account_id", null: false
    t.integer "task_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_audit_logs_on_account_id"
    t.index ["task_id"], name: "index_audit_logs_on_task_id"
  end

  create_table "auth_identities", force: :cascade do |t|
    t.string "provider"
    t.string "login"
    t.string "token"
    t.string "uid"
    t.integer "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_auth_identities_on_account_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "status"
    t.integer "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "cost", default: 0, null: false
    t.index ["account_id"], name: "index_tasks_on_account_id"
  end

  add_foreign_key "audit_logs", "accounts"
  add_foreign_key "audit_logs", "tasks"
  add_foreign_key "auth_identities", "accounts"
  add_foreign_key "tasks", "accounts"
end
