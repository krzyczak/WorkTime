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
    .select("SUM(gr3) as gr3")
    .select("SUM(gr4) as gr4")
    .select("SUM(gr5) as gr5")
    .select("SUM(gr6) as gr6")
    .select("SUM(gr7) as gr7")
    .select("SUM(gr8) as gr8")
    .select("SUM(gr9) as gr9")
    .select("SUM(other_work) as other_work")
    .select("SUM(cleaning) as cleaning")
    .select("SUM(layover) as layover")
    .select("SUM(correction) as correction")
    .select("SUM(all_work_time) as all_work_time")
    .select("SUM(breaks) as breaks")
    .select("work_records.id as work_record_id")
    .joins('LEFT JOIN employees ON employees.id = work_records.employee_id')
    .where(:department_id => department_id).where("date >= ?", start_date).where("date <= ?", end_date)
    .group(:employee_id).order("last_name ASC")
    
    @grx = WorkRecord.where(:department_id => department_id).where("date >= ?", start_date).where("date <= ?", end_date)
    
    #@gr3_sum = @grx.inject(0.0) {|sum, wr| sum += wr.gr3 }
    #@gr4_sum = @grx.inject(0.0) {|sum, wr| sum += wr.gr4 }
    #@gr5_sum = @grx.inject(0.0) {|sum, wr| sum += wr.gr5 }
    #@gr6_sum = @grx.inject(0.0) {|sum, wr| sum += wr.gr6 }
    #@gr7_sum = @grx.inject(0.0) {|sum, wr| sum += wr.gr7 }
    #@gr8_sum = @grx.inject(0.0) {|sum, wr| sum += wr.gr8 }
    #@gr9_sum = @grx.inject(0.0) {|sum, wr| sum += wr.gr9 }
    
    @gr3_sum = BigDecimal.new('0.0')
    @gr4_sum = BigDecimal.new('0.0')
    @gr5_sum = BigDecimal.new('0.0')
    @gr6_sum = BigDecimal.new('0.0')
    @gr7_sum = BigDecimal.new('0.0')
    @gr8_sum = BigDecimal.new('0.0')
    @gr9_sum = BigDecimal.new('0.0')
    
    @grx.each do |wr|
      @gr3_sum += wr.gr3
      @gr4_sum += wr.gr4
      @gr5_sum += wr.gr5
      @gr6_sum += wr.gr6
      @gr7_sum += wr.gr7
      @gr8_sum += wr.gr8
      @gr9_sum += wr.gr9
    end
    
    ## added code
    
    #all_work_time > 0 ? ( accord_all_groups/(all_work_time-other_work-cleaning-layover-correction) ) : 0.0
    @other_work_sum = @work_records.inject(0.0) {|sum, wr| sum += wr.other_work }
    @cleaning_sum   = @work_records.inject(0.0) {|sum, wr| sum += wr.cleaning }
    @layover_sum    = @work_records.inject(0.0) {|sum, wr| sum += wr.layover }
    @correction_sum = @work_records.inject(0.0) {|sum, wr| sum += wr.correction }
    @breaks_sum     = @work_records.inject(0.0) {|sum, wr| sum += wr.breaks }
    
    ## end of added code
    
    @accord_sum = @work_records.inject(0.0) {|sum, wr| sum += wr.accord_all_groups }
    @all_work_time_sum = @work_records.inject(0.0) {|sum, wr| sum += wr.all_work_time }
    #@productivity_sum = @all_work_time_sum > 0 ? @accord_sum/@all_work_time_sum : 0.0
    @productivity_sum = @all_work_time_sum > 0 ? @accord_sum/(@all_work_time_sum-@other_work_sum-@cleaning_sum-@layover_sum-@correction_sum) : 0.0
    
    store_target_location
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
    session[:return_to] = request.referer
  end

  def create
    @work_record = WorkRecord.new(params[:work_record])
    @work_record.department = Department.find(session[:department_id])
    @work_record.breaks = @work_record.calculate_breaks
    @work_record.all_work_time -= @work_record.breaks

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
    @work_record.all_work_time = BigDecimal.new(params[:work_record][:all_work_time])
    @work_record.breaks = @work_record.calculate_breaks
    @work_record.all_work_time -= @work_record.breaks

    params[:work_record].delete :all_work_time
    params[:work_record].delete :breaks

    if @work_record.update_attributes(params[:work_record])
      redirect_to_target_or_default(@work_record, :notice => t(:successfully_updated_work_record))
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
end
