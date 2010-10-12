class AddDateToWorkRecord < ActiveRecord::Migration
  def self.up
    add_column :work_records, :date, :date
  end

  def self.down
    remove_column :work_records, :date
  end
end
