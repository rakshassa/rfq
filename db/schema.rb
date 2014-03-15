# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140315104215) do

  create_table "eaus", force: true do |t|
    t.integer  "rfqform_id"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "eaus", ["rfqform_id"], name: "index_eaus_on_rfqform_id"

  create_table "employees", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "parts", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rfqforms", force: true do |t|
    t.date     "date"
    t.string   "release_type"
    t.string   "launch_date"
    t.string   "ppap"
    t.integer  "req_by"
    t.integer  "engineer"
    t.text     "info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rfqforms", ["id"], name: "index_rfqforms_on_id"

  create_table "rfqparts", force: true do |t|
    t.integer  "rfqform_id"
    t.integer  "part_number"
    t.string   "revision"
    t.integer  "qty"
    t.string   "units"
    t.text     "rfqpartvendors"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rfqparts", ["rfqform_id"], name: "index_rfqparts_on_rfqform_id"

  create_table "rfqquotes", force: true do |t|
    t.integer  "rfqform_id"
    t.integer  "vendor_id"
    t.integer  "part_id"
    t.string   "parts_note"
    t.float    "unit_price"
    t.boolean  "no_quote"
    t.string   "quote_note"
    t.string   "quote_number"
    t.date     "quote_date"
    t.string   "submitted_by"
    t.string   "feedback"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.boolean  "isTLX"
    t.integer  "vendor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vendors", force: true do |t|
    t.string   "name"
    t.boolean  "active_rfq"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
