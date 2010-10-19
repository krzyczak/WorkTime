class AddMonthlyFieldsToWorkRecord < ActiveRecord::Migration
  def self.up
    add_column :work_records, :overtime50,       :decimal, :null => false, :default => 0.0, :precision => 8, :scale => 2
    add_column :work_records, :overtime100,      :decimal, :null => false, :default => 0.0, :precision => 8, :scale => 2
    add_column :work_records, :vacation_leave,   :decimal, :null => false, :default => 0.0, :precision => 8, :scale => 2
    add_column :work_records, :occasional_leave, :decimal, :null => false, :default => 0.0, :precision => 8, :scale => 2
    add_column :work_records, :care_leave,       :decimal, :null => false, :default => 0.0, :precision => 8, :scale => 2
    add_column :work_records, :sickness,         :decimal, :null => false, :default => 0.0, :precision => 8, :scale => 2
    add_column :work_records, :nn,               :decimal, :null => false, :default => 0.0, :precision => 8, :scale => 2
  end

  def self.down
    remove_column :work_records, :nn
    remove_column :work_records, :sickness
    remove_column :work_records, :care_leave
    remove_column :work_records, :occasional_leave
    remove_column :work_records, :vacation_leave
    remove_column :work_records, :overtime100
    remove_column :work_records, :overtime50
  end
end
