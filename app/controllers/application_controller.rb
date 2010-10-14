#encoding: UTF-8

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def last_day(date)
    last_day = Date.civil(date.year, date.month, -1).day
  end
  
  def provide_print_version_if_requested
    if params[:print] == "true"
      render :layout => 'print'
    end
  end
end
