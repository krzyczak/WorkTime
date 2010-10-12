#encoding: UTF-8

class Department < ActiveRecord::Base
  has_many :employees
  has_many :work_records
end
