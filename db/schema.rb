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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120420191724) do

  create_table "cars", :force => true do |t|
    t.integer   "person_id"
    t.integer   "seats"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.string    "name"
    t.integer   "created_by_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "memberships", :force => true do |t|
    t.integer   "person_id"
    t.integer   "group_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "people", :force => true do |t|
    t.string    "name"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.boolean   "has_car"
    t.string    "signup_ip"
    t.string    "login_ip"
    t.string    "password_digest"
  end

  create_table "places", :force => true do |t|
    t.string   "name"
    t.boolean  "walkable"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "person_id"
    t.time     "leaving_at"
    t.string   "notes"
    t.integer  "votes_count", :default => 0
  end

  create_table "votes", :force => true do |t|
    t.integer   "place_id"
    t.integer   "person_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "car_id"
    t.string    "comment"
  end

end
