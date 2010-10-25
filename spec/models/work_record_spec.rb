require 'spec_helper'

describe WorkRecord do
  before(:each) do
    @w = WorkRecord.new
  #  Banner.delete_all
  #  @valid_attributes = {
  #    :name => "banner_name",
  #    :max_height => 1,
  #    :max_width => 1,
  #    :structure => false
  #  }
  end

  it "should return correct value when counting accord from all groups" do
    @w.accord_all_groups.should == 0.0
    
    @w.gr3 = @w.gr4 =  @w.gr5 =  @w.gr6 =  @w.gr7 =  @w.gr8 =  @w.gr9 = 2.5
    @w.accord_all_groups.should == 17.5
  end
  
  it "should return correct productivity" do
    @w.all_work_time = 0
    @w.productivity.should == "0.0 %"
    
    @w.all_work_time = 465.0
    @w.gr3 = @w.gr4 =  @w.gr5 =  @w.gr6 =  @w.gr7 =  @w.gr8 =  @w.gr9 = (465.0/7)
    @w.layover = (465.0/7)
    @w.productivity.should == "116.67 %"
  end
end
