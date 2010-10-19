#encoding: UTF-8

class EmployeesController < ApplicationController
  def index
    @employees = (department_select == 'all' ? Employee.select : Employee.where(:department_id => department_select)).order("last_name ASC")
  end

  def show
    @employee = Employee.find(params[:id])
    
    #dump db data
    #result1 = system("mysqldump -u root -p'w0j0wn!k' --skip-extended-insert worktime_development > work_time.html")
    
    #send email
    #result2 = system("sendemail -f jkaczmarczyk@wwgroup.internetdsl.pl -t krzyczak@gmail.com -s mail.internetdsl.pl -xu jkaczmarczyk@wwgroup.internetdsl.pl -xp 2jkgr1957 -m Pozostało urlopu: #{@employee.remaining_vacation_leave} -a work_time.html")
    #now we can tell user if the action was success and what to do because result is true if system command was succes and is false otherwise
    #render "RESULT1: #{result1}\n\n RESULT2: #{result2}"
  end

  def new
    @employee = Employee.new
    @departments = Department.all
  end

  def edit
    @employee = Employee.find(params[:id])
    @departments = Department.all
  end

  def create
    params[:employee][:department] = Department.find( (params[:employee][:department]).to_i )
    @employee = Employee.new(params[:employee])

    if @employee.save
      redirect_to(@employee, :notice => t(:successfully_added_employee))
    else
      @departments = Department.all
      render :action => "new"
    end
  end

  def update
    params[:employee][:department] = Department.find( (params[:employee][:department]).to_i )
    @employee = Employee.find(params[:id])

    if @employee.update_attributes(params[:employee])
      redirect_to(@employee, :notice => t(:successfully_updated_employee))
    else
      @departments = Department.all
      render :action => "edit"
    end
  end

  def destroy
    @employee = Employee.find(params[:id])
    @employee.destroy

    redirect_to(employees_url)
  end
  
  private
  
  def department_select
    Department.all.collect { |d| d.id.to_s }.include?(params[:department]) ? params[:department] : "all"
  end
end
