class CreateWorkRecords < ActiveRecord::Migration
  def self.up
    create_table :work_records do |t|
      t.integer :employee_id
      t.decimal :gr3, :null => false, :default => 0.0, :precision => 8, :scale => 4
      t.decimal :gr4, :null => false, :default => 0.0, :precision => 8, :scale => 4
      t.decimal :gr5, :null => false, :default => 0.0, :precision => 8, :scale => 4
      t.decimal :gr6, :null => false, :default => 0.0, :precision => 8, :scale => 4
      t.decimal :gr7, :null => false, :default => 0.0, :precision => 8, :scale => 4
      t.decimal :gr8, :null => false, :default => 0.0, :precision => 8, :scale => 4
      t.decimal :gr9, :null => false, :default => 0.0, :precision => 8, :scale => 4
      t.decimal :other_work, :null => false, :default => 0.0, :precision => 8, :scale => 4
      t.decimal :cleaning, :null => false, :default => 0.0, :precision => 8, :scale => 4
      t.decimal :layover, :null => false, :default => 0.0, :precision => 8, :scale => 4
      t.decimal :correction, :null => false, :default => 0.0, :precision => 8, :scale => 4
      t.decimal :all_work_time, :null => false, :default => 0.0, :precision => 8, :scale => 4

      t.timestamps
    end
  end

  def self.down
    drop_table :work_records
  end
end
