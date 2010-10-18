#encoding: UTF-8

class Employee < ActiveRecord::Base
  has_many :work_records, :dependent => :destroy
  belongs_to :department
  
  validates_presence_of :first_name, :last_name
  
  def remaining_vacation_leave
    minutes_of_used_vacation_leave = 0
    work_records.each do |wr|
      minutes_of_used_vacation_leave += wr.vacation_leave
    end
    (due_vacation_leave - (minutes_of_used_vacation_leave/480)).to_i
  end
end
