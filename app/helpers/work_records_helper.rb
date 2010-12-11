module WorkRecordsHelper
  def nice_procent_display(value)
    "#{(value*100).round(2)} %"
  end
end
