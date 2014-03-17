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

ActiveRecord::Schema.define(version: 20140317101145) do

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

  add_index "employees", ["id"], name: "index_employees_on_id"

  create_table "feedbacks", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feedbacks", ["id"], name: "index_feedbacks_on_id"

  create_table "parts", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "parts", ["id"], name: "index_parts_on_id"

  create_table "rfqforms", force: true do |t|
    t.date     "date"
    t.string   "release_type"
    t.string   "launch_date"
    t.string   "ppap"
    t.integer  "req_by"
    t.integer  "engineer"
    t.text     "info"
    t.boolean  "built"
    t.integer  "program"
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
    t.string   "drawing_file_name"
    t.string   "drawing_content_type"
    t.integer  "drawing_file_size"
    t.datetime "drawing_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rfqparts", ["id"], name: "index_rfqparts_on_id"
  add_index "rfqparts", ["rfqform_id", "part_number"], name: "index_rfqparts_on_rfqform_id_and_part_number", unique: true
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

  add_index "rfqquotes", ["id"], name: "index_rfqquotes_on_id"
  add_index "rfqquotes", ["rfqform_id", "vendor_id", "part_id"], name: "index_rfqquotes_on_rfqform_id_and_vendor_id_and_part_id", unique: true

  create_table "users", force: true do |t|
    t.string   "name"
    t.boolean  "isTLX"
    t.integer  "vendor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["id"], name: "index_users_on_id"

  create_table "vendor_contacts", force: true do |t|
    t.integer  "vendor_id"
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vendor_contacts", ["id"], name: "index_vendor_contacts_on_id"

  create_table "vendors", force: true do |t|
    t.string   "name"
    t.boolean  "active_rfq"
    t.integer  "rfq_contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vendors", ["id"], name: "index_vendors_on_id"

end
