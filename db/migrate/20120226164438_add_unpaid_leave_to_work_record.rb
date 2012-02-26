class AddUnpaidLeaveToWorkRecord < ActiveRecord::Migration
  def self.up
    add_column :work_records, :unpaid_leave, :decimal, :null => false, :default => 0.0, :precision => 8, :scale => 2
  end

  def self.down
    remove_column :work_records, :unpaid_leave
  end
end
