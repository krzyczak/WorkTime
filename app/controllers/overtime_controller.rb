#encoding: UTF-8

class OvertimeController < ApplicationController
  def index
    @current_year = params[:year] || Date.today.year
    @current_mont = Date.today.month
    
    @start_date = Date.parse("01.01.#{@current_year}")
    @end_date = Date.parse("31.12.#{@current_year}")
    
    @years = []
    (@current_year.to_i-10).upto(@current_year.to_i+10) {|y| @years.push(["#{y} r.", y])}
    
    @work_records = WorkRecord.select("employee_id").select("SUM(overtime50) as overtime50")
    .select("SUM(overtime100) as overtime100").select("last_name")
    .joins('LEFT JOIN employees ON employees.id = work_records.employee_id')
    .where("date >= ?", @start_date).where("date <= ?", @end_date)
    .group(:employee_id).order('last_name ASC')
    
    provide_print_version_if_requested
  end
  
  def show
    @month = (params[:month] || Date.today.month).to_i
    @year  = (params[:year] || Date.today.year).to_i
    
    start_date = Date.new(@year, @month, 1)
    # end_date = (Date.new(@year, @month+1, 1)-1)
    end_date = get_end_date_of_month(@year, @month)
    
    @employees = Employee.all
    
    employee_id = params[:employee_id] || Employee.first.id
    
    @work_records = WorkRecord
    .select("employee_id")
    .select("gr3")
    .select("gr4")
    .select("gr5")
    .select("gr6")
    .select("gr7")
    .select("gr8")
    .select("gr9")
    .select("date")
    .where("date >= ?", start_date).where("date <= ?", end_date)
    .where("employee_id = ?", employee_id)
    
    @sum = WorkRecord
    .select("employee_id")
    .select("SUM(gr3) as gr3")
    .select("SUM(gr4) as gr4")
    .select("SUM(gr5) as gr5")
    .select("SUM(gr6) as gr6")
    .select("SUM(gr7) as gr7")
    .select("SUM(gr8) as gr8")
    .select("SUM(gr9) as gr9")
    .where("date >= ?", start_date).where("date <= ?", end_date)
    .where("employee_id = ?", employee_id)
    .group(:employee_id).all
    
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

  private
  def get_end_date_of_month(year, month)
      if month < 12
        (Date.new(year, month+1, 1)-1)
    else
        Date.new(year, 12, 31)
    end
  end
  
end

