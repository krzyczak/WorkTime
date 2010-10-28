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

ActiveRecord::Schema.define(:version => 20101028122001) do

  create_table "departments", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employees", :force => true do |t|
    t.integer  "department_id"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "due_vacation_leave", :default => 26, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "due_care_leave",     :default => 2,  :null => false
  end

  create_table "work_records", :force => true do |t|
    t.integer  "employee_id"
    t.decimal  "gr3",              :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.decimal  "gr4",              :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.decimal  "gr5",              :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.decimal  "gr6",              :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.decimal  "gr7",              :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.decimal  "gr8",              :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.decimal  "gr9",              :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.decimal  "other_work",       :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.decimal  "cleaning",         :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.decimal  "layover",          :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.decimal  "correction",       :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.decimal  "all_work_time",    :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.decimal  "breaks",           :precision => 8, :scale => 2
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "department_id"
    t.decimal  "overtime50",       :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.decimal  "overtime100",      :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.decimal  "vacation_leave",   :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.decimal  "occasional_leave", :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.decimal  "care_leave",       :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.decimal  "sickness",         :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.decimal  "nn",               :precision => 8, :scale => 2, :default => 0.0, :null => false
  end

end
