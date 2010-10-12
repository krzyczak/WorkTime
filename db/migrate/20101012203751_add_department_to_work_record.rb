class AddDepartmentToWorkRecord < ActiveRecord::Migration
  def self.up
    add_column :work_records, :department_id, :integer
  end

  def self.down
    remove_column :work_records, :department_id
  end
end
