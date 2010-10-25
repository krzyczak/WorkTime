require 'spec_helper'

describe Employee do
  before(:each) do
    @employee = Employee.new
    @employee.due_vacation_leave = 26
  end

  it "should return correct remaining_vacation_leave" do
    @employee.remaining_vacation_leave.should == 26
    @employee.work_records = []
    work_record = WorkRecord.new
    work_record.vacation_leave = 480.0
    @employee.work_records.push work_record
    @employee.remaining_vacation_leave.should == 25
  end
end
