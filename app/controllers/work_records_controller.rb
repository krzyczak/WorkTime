#encoding: UTF-8

class WorkRecordsController < ApplicationController
  def index
    if params[:report] == nil
      params[:report] = Hash.new
      params[:report][:start_date] = "#{Date.today.day}-#{Date.today.month}-#{Date.today.year}"
      params[:department_id] = 1
      
      params[:report][:monthly] = "false"
    end
    
    start_date = Date.parse(params[:report][:start_date])
    end_date = start_date
    
    if params[:report][:monthly] == "true"
      last_day = Date.civil(start_date.year, start_date.month, -1).day
      start_date = Date.civil(start_date.year, start_date.month, 1)
      end_date = Date.civil(start_date.year, start_date.month, last_day)
    end
    department_id = params[:department_id].to_i
    employees = Employee.where(:department_id => department_id)
    
    @work_records = WorkRecord
    .select("work_records.*")
    .select("SUM(gr3) as gr3_sum")
    .select("SUM(gr4) as gr4_sum")
    .select("SUM(gr5) as gr5_sum")
    .select("SUM(gr6) as gr6_sum")
    .select("SUM(gr7) as gr7_sum")
    .select("SUM(gr8) as gr8_sum")
    .select("SUM(gr9) as gr9_sum")
    .select("SUM(other_work) as other_work_sum")
    .select("SUM(cleaning) as cleaning_sum")
    .select("SUM(layover) as layover_sum")
    .select("SUM(correction) as correction_sum")
    .select("SUM(all_work_time) as all_work_time_sum")
    .select("SUM(breaks) as breaks_sum")
    .select("work_records.id as work_record_id")
    .joins('LEFT JOIN employees ON employees.id = work_records.employee_id')
    .where(:department_id => department_id).where("date >= ?", start_date).where("date <= ?", end_date)
    .group(:employee_id).order("last_name ASC")
    
    #the code below needs to be commented out if DB system SUM() functions returns numbers instead of String
    #e.g. SQLite works that way
    @work_records.each do |wr|
      wr.gr3_sum = BigDecimal.new(wr.gr3_sum)
      wr.gr4_sum = BigDecimal.new(wr.gr4_sum)
      wr.gr5_sum = BigDecimal.new(wr.gr5_sum)
      wr.gr6_sum = BigDecimal.new(wr.gr6_sum)
      wr.gr7_sum = BigDecimal.new(wr.gr7_sum)
      wr.gr8_sum = BigDecimal.new(wr.gr8_sum)
      wr.gr9_sum = BigDecimal.new(wr.gr9_sum)
      
      wr.other_work_sum = BigDecimal.new(wr.other_work_sum)
      wr.cleaning_sum = BigDecimal.new(wr.cleaning_sum)
      wr.layover_sum = BigDecimal.new(wr.layover_sum)
      wr.correction_sum = BigDecimal.new(wr.correction_sum)
      wr.all_work_time_sum = BigDecimal.new(wr.all_work_time_sum)
      wr.breaks_sum = BigDecimal.new(wr.breaks_sum)
    end
    
    provide_print_version_if_requested
  end

  def show
    @work_record = WorkRecord.find(params[:id])
  end

  def new
    @employees = get_employees_for_report
    
    if params[:employee_id].nil?
      params[:employee_id] = @employees.first.id
    end
    
    @work_record = WorkRecord.new
    @work_record.employee = Employee.find(params[:employee_id])
    @work_record.date = session[:report_date]
    @submit_button_text = "Dalej"
  end

  def edit
    @work_record = WorkRecord.find(params[:id])
    @submit_button_text = "Zatwierdź"
  end

  def create
    @work_record = WorkRecord.new(params[:work_record])
    @work_record.department = Department.find(session[:department_id])

    if @work_record.save
      done_count = (WorkRecord.where(:department_id => session[:department_id]).where(:date => session[:report_date])).count
      
      if done_count == Employee.where(:department_id => session[:department_id]).count
        redirect_to(work_records_path, :notice => t(:successfully_added_work_record))
      else
        redirect_to(new_work_record_path, :notice => t(:successfully_added_work_record))
      end
    else
      @submit_button_text = "Dalej"
      @employees = get_employees_for_report
      render :action => "new"
    end
  end

  def update
    @work_record = WorkRecord.find(params[:id])

    if @work_record.update_attributes(params[:work_record])
      redirect_to(@work_record, :notice => t(:successfully_updated_work_record))
    else
      @submit_button_text = "Zatwierdź"
      render :action => "edit"
    end
  end

  def destroy
    @work_record = WorkRecord.find(params[:id])
    @work_record.destroy

    redirect_to(work_records_url)
  end
  
  def configure_report
    @departments = Department.all
  end
  
  def create_report_configuration
    #this method should be optimized and cleaned in the future
    session[:department_id] = params[:department_id].to_i
    
    report_date = Date.parse(params[:report_configuration][:date])
    session[:report_date] = report_date
    
    work_records_done = WorkRecord.where(:department_id => session[:department_id]).where(:date => session[:report_date])
    
    if work_records_done.count == Employee.where(:department_id => session[:department_id]).count
      msg = "Na dzień #{report_date}, dla działu #{Department.find(session[:department_id]).name}
      wprowadzono już dane wszystkich pracowników."
      redirect_to(work_records_path, :notice => msg)
    else
      redirect_to new_work_record_path
    end
  end
  
  private
  
  def get_employees_for_report
    work_records_done = WorkRecord.where(:date => session[:report_date]).where(:department_id => session[:department_id])
    employees_done = []
    work_records_done.each {|wr| employees_done.push wr.employee }
    return Employee.where(:department_id => session[:department_id]).all.select {|e| employees_done.include?(e) == false }
  end
  
  #def get_employees_for_report1(employees, last_employee_id)
  #  #this method should be optimized in the future
  #  employees.each do |e|
  #    employees = employees.reverse
  #    employees.pop
  #    employees = employees.reverse
  #    
  #    if e.id == last_employee_id
  #      return employees
  #    end
  #  end
  #  employees
  #end
  #
  #def next_employee_id
  #  #this method should be optimized in the future
  #  employees = Employee.where(:department_id => session[:department_id])
  #  get_employees_for_report(employees, session[:employee_id]).first.id
  #end
end
