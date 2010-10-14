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

ActiveRecord::Schema.define(:version => 20101014112306) do

  create_table "departments", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employees", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "department_id"
  end

  create_table "work_records", :force => true do |t|
    t.integer  "employee_id"
    t.decimal  "gr3",           :default => 0.0, :null => false
    t.decimal  "gr4",           :default => 0.0, :null => false
    t.decimal  "gr5",           :default => 0.0, :null => false
    t.decimal  "gr6",           :default => 0.0, :null => false
    t.decimal  "gr7",           :default => 0.0, :null => false
    t.decimal  "gr8",           :default => 0.0, :null => false
    t.decimal  "gr9",           :default => 0.0, :null => false
    t.decimal  "other_work",    :default => 0.0, :null => false
    t.decimal  "cleaning",      :default => 0.0, :null => false
    t.decimal  "layover",       :default => 0.0, :null => false
    t.decimal  "correction",    :default => 0.0, :null => false
    t.decimal  "all_work_time", :default => 0.0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "date"
    t.integer  "department_id"
    t.decimal  "breaks"
    t.decimal  "overtime50"
    t.decimal  "overtime100"
    t.decimal  "leave"
    t.decimal  "sickness"
    t.decimal  "nn"
  end

end
