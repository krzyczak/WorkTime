#encoding: UTF-8

class WorkRecord < ActiveRecord::Base
  belongs_to :employee
  belongs_to :department
  
  
  validates_numericality_of :gr3, :gr4, :gr5, :gr6, :gr7, :gr8, :gr9, :other_work, :cleaning, :layover, :correction, :all_work_time,
    :overtime50, :overtime100, :vacation_leave, :occasional_leave, :sickness, :nn,
    :greater_than_or_equal_to => 0
  
  #validates :gr3, :gr4, :gr5, :gr6, :gr7, :gr8, :gr9, :other_work, :cleaning, :layover, :correction, :all_work_time,
  #  :numericality => true,
  #  :presence => true,
  #  :greater_than_or_equal_to => 0
  
  def accord_all_groups
    gr3+gr4+gr5+gr6+gr7+gr8+gr9
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
end
