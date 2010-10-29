require 'spec_helper'

describe WorkRecord do
  before(:each) do
    @wr = WorkRecord.new
  end

  it "should return correct value when counting accord from all groups" do
    @wr.accord_all_groups.should == 0.0
    
    @wr.gr3 = @wr.gr4 =  @wr.gr5 =  @wr.gr6 =  @wr.gr7 =  @wr.gr8 =  @wr.gr9 = 2.5
    @wr.accord_all_groups.should == 17.5
  end
  
  it "should return correct productivity" do
    @wr.all_work_time = 0
    @wr.productivity.should == "0.0 %"
    
    @wr.all_work_time = 465.0
    @wr.gr3 = @wr.gr4 =  @wr.gr5 =  @wr.gr6 =  @wr.gr7 =  @wr.gr8 =  @wr.gr9 = (465.0/7)
    @wr.layover = (465.0/7)
    @wr.productivity.should == "116.67 %"
  end
  
  it "should return 15 minutes of breaks when all work time is greater than 360 minutes" do
    @wr.all_work_time = 361
    @wr.calculate_breaks.should == 15
  end
  
  it "should return 0 minutes of breaks when all work time is smaller than or equal to 360 minutes" do
    @wr.all_work_time = 360
    @wr.calculate_breaks.should == 0
  end
end
