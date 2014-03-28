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

ActiveRecord::Schema.define(version: 20140324185547) do

  create_table "contact_roles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "eaus", force: true do |t|
    t.integer  "rfqform_id"
    t.integer  "value",      limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "eaus", ["rfqform_id"], name: "index_eaus_on_rfqform_id", using: :btree

  create_table "employees", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.boolean  "inactive"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "employees", ["id"], name: "index_employees_on_id", using: :btree

  create_table "feedbacks", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feedbacks", ["id"], name: "index_feedbacks_on_id", using: :btree

  create_table "parts", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "parts", ["id"], name: "index_parts_on_id", using: :btree

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

  add_index "rfqforms", ["id"], name: "index_rfqforms_on_id", using: :btree

  create_table "rfqparts", force: true do |t|
    t.integer  "rfqform_id"
    t.integer  "part_number"
    t.string   "revision"
    t.float    "qty"
    t.string   "units"
    t.text     "rfqpartvendors"
    t.string   "drawing"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rfqparts", ["id"], name: "index_rfqparts_on_id", using: :btree
  add_index "rfqparts", ["rfqform_id"], name: "index_rfqparts_on_rfqform_id", using: :btree

  create_table "rfqquote_eaus", force: true do |t|
    t.integer  "rfqquote_id"
    t.integer  "eau_id"
    t.string   "parts_note"
    t.integer  "unit_price",  limit: 8
    t.boolean  "no_quote"
    t.integer  "tooling",     limit: 8
    t.integer  "nre",         limit: 8
    t.string   "feedback"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rfqquote_eaus", ["rfqquote_id", "eau_id"], name: "index_rfqquote_eaus_on_rfqquote_id_and_eau_id", unique: true, using: :btree
  add_index "rfqquote_eaus", ["rfqquote_id"], name: "index_rfqquote_eaus_on_rfqquote_id", using: :btree

  create_table "rfqquotes", force: true do |t|
    t.integer  "rfqform_id"
    t.integer  "vendor_id"
    t.integer  "part_id"
    t.integer  "rfqquote_display_id"
    t.string   "quote_note"
    t.string   "quote_number"
    t.date     "quote_date"
    t.string   "submitted_by"
    t.date     "valid_till"
    t.boolean  "exceptions"
    t.boolean  "submitted_to_tlx"
    t.date     "date_submitted"
    t.boolean  "feedback_sent"
    t.date     "date_feedback_sent"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rfqquotes", ["id"], name: "index_rfqquotes_on_id", using: :btree
  add_index "rfqquotes", ["rfqform_id", "vendor_id", "part_id"], name: "index_rfqquotes_on_rfqform_id_and_vendor_id_and_part_id", unique: true, using: :btree

  create_table "searches", force: true do |t|
    t.string   "built"
    t.string   "vendor"
    t.integer  "program"
    t.integer  "rfq"
    t.string   "quote_number"
    t.string   "date_built"
    t.string   "date_quoted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "searches", ["id"], name: "index_searches_on_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.boolean  "isTLX"
    t.integer  "vendor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["id"], name: "index_users_on_id", using: :btree

  create_table "vendor_addresses", force: true do |t|
    t.integer  "vendor_id"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.integer  "address_type_id"
    t.boolean  "primary"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vendor_addresses", ["id"], name: "index_vendor_addresses_on_id", using: :btree
  add_index "vendor_addresses", ["vendor_id"], name: "index_vendor_addresses_on_vendor_id", using: :btree

  create_table "vendor_contact_roles", force: true do |t|
    t.integer  "vendor_contact_id"
    t.integer  "contact_role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vendor_contact_roles", ["contact_role_id"], name: "index_vendor_contact_roles_on_contact_role_id", using: :btree
  add_index "vendor_contact_roles", ["vendor_contact_id"], name: "index_vendor_contact_roles_on_vendor_contact_id", using: :btree

  create_table "vendor_contacts", force: true do |t|
    t.integer  "vendor_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vendor_contacts", ["id"], name: "index_vendor_contacts_on_id", using: :btree
  add_index "vendor_contacts", ["vendor_id"], name: "index_vendor_contacts_on_vendor_id", using: :btree

  create_table "vendors", force: true do |t|
    t.string   "name"
    t.boolean  "active_rfq"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vendors", ["id"], name: "index_vendors_on_id", using: :btree

end
