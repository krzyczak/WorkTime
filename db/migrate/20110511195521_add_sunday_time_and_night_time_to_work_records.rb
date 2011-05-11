class AddSundayTimeAndNightTimeToWorkRecords < ActiveRecord::Migration
  def self.up
    add_column :work_records, :sunday_time, :decimal, :null => false, :default => 0.0, :precision => 8, :scale => 2
    add_column :work_records, :night_time, :decimal, :null => false, :default => 0.0, :precision => 8, :scale => 2
  end

  def self.down
    remove_column :work_records, :night_time
    remove_column :work_records, :sunday_time
  end
end
