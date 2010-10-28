class AddDueCareLeaveToEmployee < ActiveRecord::Migration
  def self.up
    add_column :employees, :due_care_leave, :integer, :null => false, :default => 2
  end

  def self.down
    remove_column :employees, :due_care_leave
  end
end
