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
end
