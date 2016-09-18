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

ActiveRecord::Schema.define(version: 20160918135035) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agents", force: :cascade do |t|
    t.string   "email",                              default: "",    null: false
    t.string   "encrypted_password",                 default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string   "name"
    t.text     "address"
    t.string   "phone"
    t.integer  "communication_preference", limit: 2
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.boolean  "admin",                              default: false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
  end

  add_index "agents", ["email"], name: "index_agents_on_email", unique: true, using: :btree
  add_index "agents", ["reset_password_token"], name: "index_agents_on_reset_password_token", unique: true, using: :btree

  create_table "applicant_signatures", force: :cascade do |t|
    t.binary   "data"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "applicant_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "applicants", force: :cascade do |t|
    t.string   "name",                            null: false
    t.date     "dob"
    t.string   "sex",                   limit: 6
    t.string   "state"
    t.string   "country"
    t.string   "facility_of_residents"
    t.string   "medicaid_number"
    t.string   "medicaid_case_worker"
    t.string   "ss_number"
    t.text     "address"
    t.string   "email"
    t.string   "phone"
    t.integer  "agent_id"
    t.text     "signature"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "envelope_id"
    t.string   "envelope_status"
  end

end
