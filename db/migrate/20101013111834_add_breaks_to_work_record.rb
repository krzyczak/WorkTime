class AddBreaksToWorkRecord < ActiveRecord::Migration
  def self.up
    add_column :work_records, :breaks, :decimal
  end

  def self.down
    remove_column :work_records, :breaks
  end
end
