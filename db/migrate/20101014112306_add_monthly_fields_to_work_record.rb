class AddMonthlyFieldsToWorkRecord < ActiveRecord::Migration
  def self.up
    add_column :work_records, :overtime50, :decimal, :null => false, :default => 0.0
    add_column :work_records, :overtime100, :decimal, :null => false, :default => 0.0
    add_column :work_records, :leave, :decimal, :null => false, :default => 0.0
    add_column :work_records, :sickness, :decimal, :null => false, :default => 0.0
    add_column :work_records, :nn, :decimal, :null => false, :default => 0.0
  end

  def self.down
    remove_column :work_records, :nn
    remove_column :work_records, :sickness
    remove_column :work_records, :leave
    remove_column :work_records, :overtime100
    remove_column :work_records, :overtime50
  end
end
