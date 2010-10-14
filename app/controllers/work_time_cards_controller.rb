#encoding: UTF-8

class WorkTimeCardsController < ApplicationController
  def index
    
  end
  
  def show
    department_id = 1
    today = Date.today
    start_date = Date.new(today.year, today.month, 1)
    end_date = Date.new(today.year, today.month, last_day(today))
    @employee = Employee.where(:department_id => department_id).first
    @work_records = @employee.work_records.where("date >= ?", start_date).where("date <= ?", end_date)
    
    whole_month = []
    0.upto(30) {|i| whole_month.push(0)}
    @work_records.each do |wr|
      whole_month[wr.date.day-1] = wr
    end
    @work_recods = whole_month
  end
end
