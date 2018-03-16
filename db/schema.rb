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

ActiveRecord::Schema.define(version: 20180314190907) do

  create_table "thx_transactions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "thx_hash"
    t.bigint "sender_id"
    t.bigint "receiver_id"
    t.integer "thx"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["receiver_id"], name: "index_thx_transactions_on_receiver_id"
    t.index ["sender_id"], name: "index_thx_transactions_on_sender_id"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "name"
    t.string "address", null: false
    t.integer "thx_balance"
    t.string "status", default: "enable", null: false
    t.boolean "verified", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address"], name: "index_users_on_address", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "thx_transactions", "users", column: "receiver_id"
  add_foreign_key "thx_transactions", "users", column: "sender_id"
end
