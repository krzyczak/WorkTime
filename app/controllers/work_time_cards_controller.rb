#encoding: UTF-8

class WorkTimeCardsController < ApplicationController
  def index
    @employees = Employee.all
    provide_meta_data
    provide_print_version_if_requested
  end
  
  def show
    @months = [['Styczeń', 1], ['Luty', 2], ['Marzec', 3], ['Kwiecień', 4], ['Maj', 5], ['Czerwiec', 6], ['Lipiec', 7], ['Sierpień', 8], ['Wrzesień', 9], ['Październik', 10], ['Listopad', 11], ['Grudzień', 12]]
    @years = []
    2000.upto(2020) {|y| @years.push(["#{y} r.", y])}
    @employee = (params[:employee_id].nil? ? Employee.first : Employee.find(params[:employee_id].to_i))
    
    if params[:report_month].nil?
      params[:report_month] = Date.today.month
    end
    
    if params[:report_year].nil?
      params[:report_year] = Date.today.year
    end
    
    @work_recods = []
    if @employee.nil? == false
    
    @report_month = params[:report_month].to_i#(params[:report_month].nil? ? Date.today.month : params[:report_month].to_i)
    @report_year = params[:report_year].to_i#(params[:report_year].nil? ? Date.today.year : params[:report_year].to_i)
    
    start_date = Date.new(@report_year, @report_month, 1)
    end_date = Date.new(@report_year, @report_month, last_day(Date.new(@report_year, @report_month, -1)))
    @work_records = @employee.work_records.where("date >= ?", start_date).where("date <= ?", end_date)
    #above won't work if we have no employees in db
    
    whole_month = []
    0.upto(30) {|i| whole_month.push(0)}
    @work_records.each do |wr|
      whole_month[wr.date.day-1] = wr
    end
    @work_recods = whole_month
    
    
    end
    provide_print_version_if_requested
  end
  
  private
  
  def provide_meta_data
    @months = [['Styczeń', 1], ['Luty', 2], ['Marzec', 3], ['Kwiecień', 4], ['Maj', 5], ['Czerwiec', 6], ['Lipiec', 7], ['Sierpień', 8], ['Wrzesień', 9], ['Październik', 10], ['Listopad', 11], ['Grudzień', 12]]
    @years = []
    2000.upto(2020) {|y| @years.push(["#{y} r.", y])}
    
    if params[:report_month].nil?
      params[:report_month] = Date.today.month
    end
    
    if params[:report_year].nil?
      params[:report_year] = Date.today.year
    end
    
    @report_month = params[:report_month].to_i#(params[:report_month].nil? ? Date.today.month : params[:report_month].to_i)
    @report_year = params[:report_year].to_i#(params[:report_year].nil? ? Date.today.year : params[:report_year].to_i)
    
    @start_date = Date.new(@report_year, @report_month, 1)
    @end_date = Date.new(@report_year, @report_month, last_day(Date.new(@report_year, @report_month, -1)))
  end
end
