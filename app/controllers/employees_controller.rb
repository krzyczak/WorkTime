#encoding: UTF-8

class EmployeesController < ApplicationController
  def index
    @employees = department_select == 'all' ? Employee.all : Employee.where(:department_id => department_select)
  end

  def show
    @employee = Employee.find(params[:id])
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
      redirect_to(@employee, :notice => 'Employee was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    params[:employee][:department] = Department.find( (params[:employee][:department]).to_i )
    @employee = Employee.find(params[:id])

    if @employee.update_attributes(params[:employee])
      redirect_to(@employee, :notice => 'Employee was successfully updated.')
    else
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
