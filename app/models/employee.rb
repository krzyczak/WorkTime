#encoding: UTF-8

class Employee < ActiveRecord::Base
  has_many :work_records, :dependent => :destroy
  belongs_to :department
  
  validates_presence_of :first_name, :last_name
  
  def remaining_vacation_leave
    due_vacation_leave - (work_records.inject(0) {|sum, wr| sum + (wr.vacation_leave/480)}).to_i
  end
  
  def remaining_care_leave
  	due_care_leave - (work_records.inject(0) {|sum, wr| sum + (wr.care_leave/480)}).to_i
  end
end
