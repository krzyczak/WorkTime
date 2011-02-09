#encoding: UTF-8

class EmployeesController < ApplicationController
  def index
    @employees = Employee.scoped
    @employees = @employees.where(:department_id => params[:department_id]) if params[:department_id]
    @employees = @employees.order("last_name ASC")
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
end
