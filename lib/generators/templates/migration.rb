class CreateTasksTable < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      #todo: t.references user/admin/whoever when running install
      
      t.integer   :user_id 
      t.integer   :task_list_id, :null => false # Tasks must belong to a list
      t.integer   :created_by
      t.string    :title
      t.string    :description
      t.boolean   :priority, :null => false, :default => false
      t.boolean   :completed
      t.datetime  :completed_at
      t.datetime  :due_date
      
      # t.string    :type
      # t.references :linkable, :polymorphic => true
      
      t.timestamps
    end
    
    create_table :task_lists do |t|
      t.string    :name
      
      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
    drop_table :task_lists
  end
end
