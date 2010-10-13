#encoding: UTF-8

module ApplicationHelper
  def nice_date_format(date)
    date.strftime("%d-%m-%Y").to_s
  end
  
  def month_name(month_index)
    puts "############################"
    puts month_index
    puts "############################"
    month_names = ['Styczeń', 'Luty', 'Marzec', 'Kwiecień', 'Maj', 'Czerwiec', 'Lipiec', 'Sierpień', 'Wrzesień', 'Październik', 'Listopad', 'Grudzień']
    month_names[month_index-1]
  end
end
