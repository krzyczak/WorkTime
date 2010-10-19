class CreateEmployees < ActiveRecord::Migration
  def self.up
    create_table :employees do |t|
      t.integer :department_id
      t.string  :first_name
      t.string  :last_name
      t.integer :due_vacation_leave, :null => false, :default => 26

      t.timestamps
    end
  end

  def self.down
    drop_table :employees
  end
end
