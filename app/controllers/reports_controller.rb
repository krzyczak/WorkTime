#encoding: UTF-8

class ReportsController < ApplicationController
  
  def show
    @current_year = (params[:year] || Date.today.year).to_i
    @years = []
    (@current_year.to_i-10).upto(@current_year.to_i+10) {|y| @years.push(["#{y} r.", y])}
    @employees = Employee.all
    @employee = params[:employee_id] ? Employee.find(params[:employee_id]) : Employee.first
    
    #@report_data = Employee.all.collect do |employee|
    @report_data = [@employee].collect do |employee|
      @ewr = WorkRecord.where(:employee_id => employee.id)
    ##############################
      @employee_data = 1.upto(12).collect do |month|
        start_date = Date.new(@current_year,month,1)
        end_date = (month > 11 ? Date.new(@current_year,12,31) : Date.new(@current_year,month+1,1)-1)
        work_records = @ewr.where("date >= ?", start_date).where("date <= ?", end_date)
        data = {
          month: month,
          all_work_time: get_report_data(work_records, :all_work_time)/60,
          breaks: get_report_data(work_records, :breaks)/60,
          overtime50: get_report_data(work_records, :overtime50)/60,
          overtime100: get_report_data(work_records, :overtime100)/60,
          vacation_leave: get_report_data(work_records, :vacation_leave)/480,
          unpaid_leave: get_report_data(work_records, :unpaid_leave)/480,
          sickness: get_report_data(work_records, :sickness)/480,
          care_leave: get_report_data(work_records, :care_leave)/480,
          nn: get_report_data(work_records, :nn)/480,
          occasional_leave: get_report_data(work_records, :occasional_leave)/480
        }
        data
      end
    ##############################
      {employee: employee, employee_data: @employee_data}
    end
    
    @all_work_time = BigDecimal.new('0.0')
    @overtime = BigDecimal.new('0.0')
    @vacation_leave = BigDecimal.new('0.0')
    @unpaid_leave = BigDecimal.new('0.0')
    @sickness = BigDecimal.new('0.0')
    @care_leave = BigDecimal.new('0.0')
    @nn = BigDecimal.new('0.0')
    @occasional_leave = BigDecimal.new('0.0')
    
    provide_print_version_if_requested
  end #show method end
  
  private
  
  def get_report_data(work_records, data_type)
    work_records.inject(BigDecimal.new("0.0")) { |sum, wr| sum += wr.send(data_type) }
  end
  
  #dane dla pojedynczego i dla wszystkich
  
  #jednostka: godziny
  #GN w godzinach
  #R w godzinach
  #urlop wypocznynkowy w dniach
  #urlop w dniach
  #chorobowe w dniach
  #opieka w dniach
  #NN w dniach
  #okolicznościowy w dniach
  
  #łączny czas przebywania w pracy (przerwa liczona odrębnie)
  
  #na dole sumy
  
end

