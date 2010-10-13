#encoding: UTF-8

class Employee < ActiveRecord::Base
  has_many :work_records, :dependent => :destroy
  belongs_to :department
  
  validates_presence_of :first_name, :last_name
end
