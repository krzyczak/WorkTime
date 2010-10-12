#encoding: UTF-8

class WorkRecordsController < ApplicationController
  def index
    #@work_records = WorkRecord.all
    if params[:report] == nil
      params[:report] = Hash.new
      params[:report][:start_date] = "#{Date.today.day}-#{Date.today.month}-#{Date.today.year}"
      params[:report][:end_date] = "#{Date.today.day}-#{Date.today.month}-#{Date.today.year}"
    end
    
    start_date = Date.parse(params[:report][:start_date])
    end_date = Date.parse(params[:report][:end_date])
    @work_records = WorkRecord.where("date >= ?", start_date).where("date <= ?", end_date).
    select("SUM(gr3) as gr3_sum, *").group(:employee_id)
  end

  def show
    @work_record = WorkRecord.find(params[:id])
  end

  def new
    #session[:employee_id] ||= Employee.first.id
    @work_record = WorkRecord.new
    @work_record.employee = Employee.find(session[:employee_id])
    @work_record.date = session[:report_date]
  end

  def edit
    @work_record = WorkRecord.find(params[:id])
  end

  def create
    @work_record = WorkRecord.new(params[:work_record])
    @work_record.department = Department.find(session[:department])

    if @work_record.save
      if @work_record.employee_id == Employee.last.id
        session[:employee_id] = nil
        redirect_to(work_records_path, :notice => 'Work record was successfully created.')
      else
        session[:employee_id] = next_employee_id
        redirect_to(new_work_record_path, :notice => 'Work record was successfully created.')
      end
    else
      render :action => "new"
    end
  end

  def update
    @work_record = WorkRecord.find(params[:id])

    if @work_record.update_attributes(params[:work_record])
      redirect_to(@work_record, :notice => 'Work record was successfully updated.')
    else
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
    
    report_date = Date.new(params[:report_configuration]["date(1i)"].to_i, params[:report_configuration]["date(2i)"].to_i, params[:report_configuration]["date(3i)"].to_i)
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
