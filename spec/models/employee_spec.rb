require 'spec_helper'

describe Employee do
  before(:each) do
    @employee = Employee.new
    @employee.due_vacation_leave = 26
    @employee.due_care_leave = 2
    @employee.first_name = "Jan"
    @employee.last_name = "Kowalski"
    @employee.save!
    
    @work_record = WorkRecord.new
    @work_record.vacation_leave = 480.0
    @work_record.care_leave = 480.0
    @work_record.employee = @employee
  end

  it "should return correct remaining_vacation_leave" do
    @work_record.date = Date.today
    @work_record.save!
    @employee.remaining_vacation_leave.should == 25
  end
  
  it "should return remaining vacation leave same as due vacation leave if the year of vacation is not current year" do
    @work_record.date = Date.parse("#{Date.today.year-10}-10-28")
    @work_record.save!
    @employee.remaining_vacation_leave.should == 26
  end
  
  it "should return correct remaining_care_leave" do
    @work_record.date = Date.today
    @work_record.save!
    @employee.remaining_care_leave.should == 1
  end
  
  it "should return remaining care leave same as due vacation leave if the year of vacation is not current year" do
    @work_record.date = Date.parse("#{Date.today.year-10}-10-28")
    @work_record.save!
    @employee.remaining_care_leave.should == 2
  end
end
