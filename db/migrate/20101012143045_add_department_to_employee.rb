class AddDepartmentToEmployee < ActiveRecord::Migration
  def self.up
    add_column :employees, :department_id, :integer
  end

  def self.down
    remove_column :employees, :department_id
  end
end
