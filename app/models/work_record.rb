#encoding: UTF-8

class WorkRecord < ActiveRecord::Base
  belongs_to :employee
  belongs_to :department
  
  def accord_sum
    gr3+gr4+gr5+gr6+gr7+gr8+gr9
  end
  
  def productivity
    ret = 0
    if all_work_time > 0
      ret = accord_sum/(all_work_time-other_work-cleaning-layover-correction)
    else
      ret = 0
    end
    "#{(ret*100).round(2)} %"
  end
  
  def breaks
    if all_work_time > 360
      15
    else
      0
    end
  end
  
  def overtime
    #ma być liczone tylko w ujęciu miesięczym, więc trzeba się zastanowić jak to zrobić...
    all_work_time - ((breaks/15)*465)
  end
end
