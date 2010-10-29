#encoding: UTF-8

class Employee < ActiveRecord::Base
  has_many :work_records, :dependent => :destroy
  belongs_to :department
  
  validates_presence_of :first_name, :last_name
  
  def remaining_vacation_leave
    start_date = Date.parse("#{Date.today.year}-01-01")
  	end_date   = Date.parse("#{Date.today.year}-12-31")
  	due_vacation_leave - (work_records.where("date >= ?", start_date).where("date <= ?", end_date).inject(0) {|sum, wr| sum + (wr.vacation_leave/480)}).to_i
  end
  
  def remaining_care_leave
  	start_date = Date.parse("#{Date.today.year}-01-01")
  	end_date   = Date.parse("#{Date.today.year}-12-31")
  	due_care_leave - (work_records.where("date >= ?", start_date).where("date <= ?", end_date).inject(0) {|sum, wr| sum + (wr.care_leave/480)}).to_i
  end
end
