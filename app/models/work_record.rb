#encoding: UTF-8

class WorkRecord < ActiveRecord::Base
  belongs_to :employee
  belongs_to :department

  scope :overtime_sum, lambda { |start_date, end_date| select("employee_id").select("SUM(overtime50) as overtime50").select("SUM(overtime100) as overtime100").select("last_name").joins('LEFT JOIN employees ON employees.id = work_records.employee_id').where("date >= ?", start_date).where("date <= ?", end_date).group(:employee_id).order('last_name ASC') }
  scope :by_employee, lambda { |start_date, end_date, employee_id| select("employee_id").select("gr3").select("gr4").select("gr5").select("gr6").select("gr7").select("gr8").select("gr9").select("date").where("date >= ?", start_date).where("date <= ?", end_date).where("employee_id = ?", employee_id) }
  scope :sum_by_employee, lambda { |start_date, end_date, employee_id| select("employee_id").select("SUM(gr3) as gr3").select("SUM(gr4) as gr4").select("SUM(gr5) as gr5").select("SUM(gr6) as gr6").select("SUM(gr7) as gr7").select("SUM(gr8) as gr8").select("SUM(gr9) as gr9").where("date >= ?", start_date).where("date <= ?", end_date).where("employee_id = ?", employee_id).group(:employee_id) }
  
  validates_numericality_of :gr3, :gr4, :gr5, :gr6, :gr7, :gr8, :gr9, :other_work, :cleaning, :layover, :correction, :all_work_time,
    :overtime50, :overtime100, :vacation_leave, :occasional_leave, :sickness, :nn,
    :greater_than_or_equal_to => 0
    
  validate :unique_record, :on => :create

  validate :overtime_entered_if_necessary
  
  def unique_record
    # errors.add_to_base("Dla tego pracownika w danym dniu, dane są już wprowadzone...\nProszę wybrać innego pracownika.") if WorkRecord.where("employee_id = ? AND date = ?", employee_id, date).count > 0
    errors.add(:base, "Dla tego pracownika w danym dniu, dane są już wprowadzone...\nProszę wybrać innego pracownika.") if WorkRecord.where("employee_id = ? AND date = ?", employee_id, date).count > 0
  end

  def overtime_entered_if_necessary
    if (all_work_time > 480 && !(overtime50+overtime100 > 0))
      errors.add(:base, "Coś nie tak z nadgodzinami. Wpisz nadgodziny lub zmniejsz czas pracy do 480 minut.")
    elsif (all_work_time <= 480 && (overtime50+overtime100 > 0))
      errors.add(:base, "Coś nie tak z nadgodzinami. Zwiększ czas pracy ponad 480 minut lub zmiejsz nadgodziny do 0.")
    end
  end
  
  #validates_uniqueness_of :employee_id, :scope => [:date]
  
  def accord_all_groups
    gr3+gr4+gr5+gr6+gr7+gr8+gr9
  end
  
  def productivity
    all_work_time > 0 ? ( accord_all_groups/(all_work_time-other_work-cleaning-layover-correction) ) : 0.0
  end
  
  def calculate_breaks
    all_work_time >= 360 ? BigDecimal.new("15") : BigDecimal.new("0")
  end

  def all_work_time_with_breaks
    all_work_time + breaks
  end
end
