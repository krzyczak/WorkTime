#encoding: UTF-8

class OvertimeController < ApplicationController
  def index
    @current_year = params[:year] || Date.today.year
    
    @start_date = Date.parse("01.01.#{@current_year}")
    @end_date = Date.parse("31.12.#{@current_year}")
    
    @years = []
    (@current_year.to_i-10).upto(@current_year.to_i+10) {|y| @years.push(["#{y} r.", y])}
    
    @work_records = WorkRecord.overtime_sum(@start_date, @end_date)
    
    provide_print_version_if_requested
  end
  
  def show
    @month = (params[:month] || Date.today.month).to_i
    @year  = (params[:year] || Date.today.year).to_i
    
    start_date = Date.new(@year, @month, 1)
    end_date = (Date.new(@year, @month+1, 1)-1)
    
    @employees = Employee.all
    
    employee_id = params[:employee_id] || Employee.first.id
    
    @work_records = WorkRecord.by_employee(start_date, end_date, employee_id)
    @sum = WorkRecord.sum_by_employee(start_date, end_date, employee_id)
    
    employee = Employee.find(employee_id)
    if @work_records.count > 0
      @employee_name = "#{@work_records.first.employee.last_name} #{@work_records.first.employee.first_name}"
    else
      @employee_name = "#{employee.last_name} #{employee.first_name}"
    end
    
    dates = Hash.new
    start_date.upto(end_date) { |day| dates[day] = 'empty' }
    @work_records.each { |wr| dates[wr.date] = wr }
    
    @work_records = dates
    
    @month_names = ['Styczeń', 'Luty', 'Marzec', 'Kwiecień', 'Maj', 'Czerwiec', 'Lipiec', 'Sierpień', 'Wrzesień', 'Październik', 'Listopad', 'Grudzień']
    @years = []
    (@year.to_i-10).upto(@year.to_i+10) {|y| @years.push(["#{y} r.", y])}
    
    provide_print_version_if_requested
  end
  
end

