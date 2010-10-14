#encoding: UTF-8

class WorkRecordsController < ApplicationController
  def index
    if params[:report] == nil
      params[:report] = Hash.new
      params[:report][:start_date] = "#{Date.today.day}-#{Date.today.month}-#{Date.today.year}"
      params[:report_monthly] = "false"
      params[:department_id] = 1
    end
    
    start_date = Date.parse(params[:report][:start_date])
    end_date = start_date
    
    if params[:report_monthly] == "true"
      last_day = Date.civil(start_date.year, start_date.month, -1).day
      start_date = Date.civil(start_date.year, start_date.month, 1)
      end_date = Date.civil(start_date.year, start_date.month, last_day)
    end
    department_id = params[:department_id]
    @work_records = WorkRecord.where(:department_id => department_id).where("date >= ?", start_date).where("date <= ?", end_date)
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
    .select("*")
    .group(:employee_id)
  end

  def show
    @work_record = WorkRecord.find(params[:id])
  end

  def new
    @work_record = WorkRecord.new
    @work_record.employee = Employee.find(session[:employee_id])
    @work_record.date = session[:report_date]
    @submit_button_text = "Dalej"
  end

  def edit
    @work_record = WorkRecord.find(params[:id])
    @submit_button_text = "Zatwierdź"
  end

  def create
    @work_record = WorkRecord.new(params[:work_record])
    @work_record.department = Department.find(session[:department])
    #@work_record.breaks = @work_record.calculate_breaks

    if @work_record.save
      if @work_record.employee_id == Employee.last.id
        session[:employee_id] = nil
        redirect_to(work_records_path, :notice => 'Pomyślnie dodano wpis.')
      else
        session[:employee_id] = next_employee_id
        redirect_to(new_work_record_path, :notice => 'Pomyślnie dodano wpis.')
      end
    else
      @submit_button_text = "Dalej"
      render :action => "new"
    end
  end

  def update
    @work_record = WorkRecord.find(params[:id])

    if @work_record.update_attributes(params[:work_record])
      #@work_record.breaks = @work_record.calculate_breaks
      #@work_record.save!
      redirect_to(@work_record, :notice => 'Pomyślnie zaktualizowano wpis.')
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
    session[:department] = params[:department].to_i
    @employees = Employee.where(:department_id => session[:department])
    
    report_date = Date.parse(params[:report_configuration][:date])
    session[:report_date] = report_date
    last_employee_id = (WorkRecord.where(:date => report_date, :department_id => session[:department]).count == 0 ? 0 : WorkRecord.where(:date => report_date).last.employee_id)
    
    @employees = (last_employee_id == 0) ? @employees : get_employees_for_report(@employees, last_employee_id)
    
    if @employees.count == 0
      redirect_to(work_records_path, :notice => "Na dzień #{report_date}, dla działu #{Department.find(session[:department]).name} wprowadzono już dane wszystkich pracowników.")
    else
      session[:employee_id] = @employees.first.id
      redirect_to new_work_record_path
    end
  end
  
  private
  
  def get_employees_for_report(employees, last_employee_id)
    #this method should be optimized in the future
    employees.each do |e|
      employees = employees.reverse
      employees.pop
      employees = employees.reverse
      
      if e.id == last_employee_id
        return employees
      end
    end
    employees
  end
  
  def next_employee_id
    #this method should be optimized in the future
    employees = Employee.where(:department_id => session[:department])
    get_employees_for_report(employees, session[:employee_id]).first.id
  end
end
