#encoding: UTF-8

class WorkRecord < ActiveRecord::Base
  belongs_to :employee
  belongs_to :department
  
  validates_numericality_of :gr3, :gr4, :gr5, :gr6, :gr7, :gr8, :gr9, :other_work, :cleaning, :layover, :correction, :all_work_time,
    :greater_than_or_equal_to => 0
  
  #validates :gr3, :gr4, :gr5, :gr6, :gr7, :gr8, :gr9, :other_work, :cleaning, :layover, :correction, :all_work_time,
  #  :numericality => true,
  #  :presence => true,
  #  :greater_than_or_equal_to => 0
  
  def accord_all_groups
    gr3+gr4+gr5+gr6+gr7+gr8+gr9
  end
  
  def accord_all_groups_sum
    gr3_sum+gr4_sum+gr5_sum+gr6_sum+gr7_sum+gr8_sum+gr9_sum
  end
  
  def productivity
    ret = 0
    if all_work_time > 0
      ret = accord_all_groups/(all_work_time-other_work-cleaning-layover-correction)
    else
      ret = 0
    end
    "#{(ret*100).round(2)} %"
  end
  
  def productivity_sum
    ret = 0.0
    if all_work_time_sum > 0
      ret = accord_all_groups_sum.to_f/(all_work_time_sum-other_work_sum-cleaning_sum-layover_sum-correction_sum)
    else
      ret = 0
    end
    "#{(ret*100).round(2)} %"
  end
  
  def calculate_breaks
    all_work_time > 360 ? breaks = 15 : breaks = 0
  end
  
  def overtime
    #all_work_time_sum-((breaks_sum/15)*465)
  end
end
